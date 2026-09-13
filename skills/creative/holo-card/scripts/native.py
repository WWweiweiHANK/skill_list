#!/usr/bin/env python3
"""Local preparation and assembly for Codex built-in image generation. No API or network calls."""
import argparse
import base64
import hashlib
import json
from pathlib import Path
import shutil
import sys
import time
import zipfile
from PIL import Image, ImageOps, ImageChops

KINDS=('character','background','ui','structure')
ROOT=Path(__file__).resolve().parents[1]
TEMPLATES=ROOT/'assets/renderer'

def prompt(kind):
    common=('Keep the entire original canvas, aspect ratio, exact positions and scale. Do not crop, recenter, redesign, '
            'change visible geometry. No new text or added glow. ')
    if kind=='structure':
        return common+'Output a black background with thin white visible structural contour lines of the main illustrated subjects, including selected internal shape boundaries. Exclude dense hair/fabric texture, checkerboard edges and editorial inset boundaries. No filled regions, text, UI or scenery lines. Use the final repaired subject layer as the reference so contours match its repaired anatomy exactly.'
    targets={
      'character':'For a photographic subject, preserve every visible subject RGB pixel from source.png and author only an aligned alpha mask; import it with apply-source-alpha. Do not use image generation to recreate, extract, restyle, recenter or resize an unobscured photographic subject. Include attached hair, clothing, tails and accessories while excluding scenery, typography, frame, editorial panels and unrelated props. If typography or damage conceals the subject, generate only the concealed repair pixels, composite them into the source-preserved layer, and leave all unaffected visible subject pixels byte-identical to source.png. Preserve anatomy, silhouette, scale, position, eyes, mouth interiors, dark colors, white highlights and shadows.',
      'background':'Automatically distinguish background scenery from foreground subjects and the combined typography/frame overlay. Produce a complete opaque COLOR background plate covering the entire canvas, including beneath the decorative border. Remove all subjects, printed text, UI and frame, and reconstruct ALL areas they concealed using the surrounding scenery, colors and directional strokes. No transparent gaps, unfilled cutout silhouettes or residual glyphs. Naturally black scenery remains black. Never substitute an enlarged, blurred or dimmed source image containing the subject. Preserve visible scenery alignment.',
      'ui':'Extract the original colored typography, numerals, symbols, information bars AND the entire original decorative border/card frame together as ONE combined UI layer at the same depth, on a regular neutral gray checkerboard matte, with no checkerboard inside the retained artwork. Keep frame and typography together, never as separate depth layers. Preserve glyphs and panel colors exactly at their original positions. Retain editorial inset panels including their images as UI, while excluding the main foreground subject and scenery. Prefer original source pixels for typography when local extraction can preserve them; reject changed lettering. Do not redraw or rearrange text.'}
    return common+targets[kind]+' Output a full-color image, NOT a black-and-white mask or grayscale image. For character and UI, the local workflow converts the checkerboard matte to an alpha mask afterward; native transparent output is not required.'

def sha(path):return hashlib.sha256(Path(path).read_bytes()).hexdigest()

def 生成透明度证据(图像):
    """返回可审计的真实 Alpha 通道证据，禁止用视觉棋盘格代替文件透明度。"""
    有透明通道='A' in 图像.getbands()
    if not 有透明通道:
        return {'classification':'opaque-no-alpha','has_alpha_channel':False,
                'alpha_min':255,'alpha_max':255,'transparent_pixels':0}
    透明通道=图像.getchannel('A')
    最小值,最大值=透明通道.getextrema()
    直方图=透明通道.histogram()
    透明像素=sum(直方图[:255])
    分类='real-alpha' if 透明像素 else 'opaque-alpha'
    return {'classification':分类,'has_alpha_channel':True,
            'alpha_min':最小值,'alpha_max':最大值,'transparent_pixels':透明像素}

def save(path,value):
    temporary=path.with_suffix(path.suffix+'.tmp')
    temporary.write_text(json.dumps(value,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
    temporary.replace(path)
def current_prompts():return {k:prompt(k) for k in KINDS}
def prompt_digest():return hashlib.sha256(json.dumps(current_prompts(),sort_keys=True).encode()).hexdigest()
def load(job):
    state=json.loads((job/'task.json').read_text(encoding='utf-8'))
    if state.get('layer_mode')!='direct_rgba':
        raise ValueError('Obsolete native mask job. Prepare a new colored-layer job; legacy prompts and extraction are no longer supported by native.py.')
    # Saved prompts are working instructions, not the generation audit trail.
    # Actual generation references and raw images remain untouched.
    expected=current_prompts()
    try:existing=json.loads((job/'prompts.json').read_text(encoding='utf-8'))
    except (OSError,ValueError):existing=None
    if existing!=expected:save(job/'prompts.json',expected)
    if state.get('prompt_digest')!=prompt_digest():
        state['prompt_digest']=prompt_digest();save(job/'task.json',state)
    return state
def summary(job,state):
    有预览=state['status'] in ('assembled_unreviewed','completed')
    return {'job_directory':str(job),'execution':state['execution'],'status':state['status'],
            'completed_layers':sum(l['status']=='imported' for l in state['layers'].values()),'total_layers':4,
            'layers':{k:{'status':v['status'],'error':v.get('error')} for k,v in state['layers'].items()},
            'prompts':str(job/'prompts.json'),'prompt_digest':state.get('prompt_digest'),
            'html':str(job/'index.html') if 有预览 else None,
            'archive':str(job/'card.zip') if 有预览 else None,
            'quality_review':state.get('quality_review')}

def prepare(source,job,name):
    if job.exists():raise ValueError('Output directory exists. Use status to resume it or choose a new directory.')
    with Image.open(source) as image:
        if image.format not in ('PNG','JPEG','WEBP') or getattr(image,'n_frames',1)!=1 or image.width*image.height>24_000_000:
            raise ValueError('Expected one PNG/JPEG/WebP frame up to 24 megapixels.')
        normalized=ImageOps.exif_transpose(image).convert('RGBA')
        normalized.thumbnail((1600,1600),Image.Resampling.LANCZOS)
    job.mkdir(parents=True,mode=0o700);(job/'masks').mkdir();(job/'raw').mkdir();(job/'assets').mkdir()
    original_name='original'+Path(source).suffix.lower();shutil.copyfile(source,job/original_name)
    normalized.save(job/'source.png')
    state={'version':3,'prompt_digest':prompt_digest(),'layer_mode':'direct_rgba','execution':'codex_builtin_image_gen','name':name or source.stem,'status':'awaiting_images','created_at':int(time.time()*1000),
           'source':{'original':original_name,'sha256':sha(source),'normalized_sha256':sha(job/'source.png'),'width':normalized.width,'height':normalized.height},
           'layers':{k:{'status':'pending','error':None} for k in KINDS},'repairs':{'background_inpainting':True,'subject_text_cleanup':True}}
    save(job/'task.json',state);save(job/'prompts.json',current_prompts())
    return {**summary(job,state),'edit_target':str(job/'source.png'),'prompts':str(job/'prompts.json'),
            'next':'Use the Codex built-in image_gen tool once per layer, then import its actual returned image path with add. No API setup is needed.'}

def add(job,kind,path,tool_reference,replace=False):
    state=load(job)
    if state['layers'][kind]['status']=='imported' and not replace:raise ValueError('This layer is already imported. Use --replace only for an explicitly selected replacement image.')
    with Image.open(path) as image:
        if image.width*image.height>16_000_000 or getattr(image,'n_frames',1)!=1:raise ValueError('Mask image is too large or animated.')
        suffix={'JPEG':'.jpg','WEBP':'.webp'}.get(image.format,'.png');raw='raw/'+kind+suffix
        if Path(path).resolve()!=(job/raw).resolve():shutil.copyfile(path,job/raw)
        if abs((image.width/image.height)/(state['source']['width']/state['source']['height'])-1)>.025:
            state['layers'][kind]={'status':'needs_review','error':'MASK_ASPECT_MISMATCH','raw':raw,'sha256':sha(path)}
            state['status']='needs_review';save(job/'task.json',state)
            raise ValueError('Mask aspect ratio differs from the source. Its raw output is saved; no crop or regeneration was performed.')
        透明度证据=生成透明度证据(image)
        rgba=image.convert('RGBA')
        if kind!='structure':
            if kind != 'background' and rgba.getchannel('A').getextrema()[0]==255:
                state['layers'][kind]={'status':'needs_alpha_mask','error':None,'raw':raw,'sha256':sha(path),'tool_reference':tool_reference,
                                       'transparency_evidence':透明度证据}
                state['status']='needs_alpha_mask';save(job/'task.json',state)
                return {**summary(job,state),'repair_input':str(job/raw),
                        'transparency_evidence':透明度证据,
                        'next_action':'Inspect the matte, prepare an aligned grayscale alpha mask for confirmed checkerboard regions, preserve artwork, then run apply-alpha. Continue locally; this is an intermediate state, not generation failure.',
                        'mask_convention':'0 removes confirmed background; 255 retains artwork; intermediate values are antialiased edges. Do not threshold artwork brightness or assume opaque pixels are checkerboard.'}
            if kind == 'background' and rgba.getchannel('A').getextrema()[0] < 255:
                state['layers'][kind]={'status':'needs_review','error':'BACKGROUND_HAS_HOLES','raw':raw,'sha256':sha(path)}
                state['status']='needs_review';save(job/'task.json',state)
                raise ValueError('Background must be fully opaque and inpainted. Raw output saved for review.')
        else:
            mask=ImageChops.multiply(rgba.convert('L'),rgba.getchannel('A'));mask.save(job/'masks'/f'{kind}.png')
    state['layers'][kind]={'status':'imported','error':None,'raw':raw,'sha256':sha(path),'format':('rgba' if kind!='structure' else 'mask'),'imported_at':int(time.time()*1000),'tool_reference':tool_reference,
                           'transparency_evidence':透明度证据}
    state['status']='ready_to_assemble' if all(v['status']=='imported' for v in state['layers'].values()) else 'awaiting_images'
    save(job/'task.json',state);return summary(job,state)

def html_document(job,state):
    data_url=lambda path:'data:image/png;base64,'+base64.b64encode(path.read_bytes()).decode()
    manifest={'name':state['name'],'width':state['source']['width'],'height':state['source']['height'],
              'assets':{k:data_url(job/'assets'/f'{k}.png') for k in KINDS},'back':data_url(TEMPLATES/'back.png')}
    if state.get('preview_url'):
        manifest['previewUrl']=state['preview_url']
        manifest['previewQr']=data_url(job/'mobile-qr.png')
    data=json.dumps(manifest,ensure_ascii=True).replace('<','\\u003c')
    renderer=(TEMPLATES/'renderer.js').read_text(encoding='utf-8').replace('export async function createCardRenderer','async function createCardRenderer')
    script='globalThis.HOLO_MANIFEST='+data+';\n'+renderer+'\nglobalThis.HOLO_CREATE_RENDERER=createCardRenderer;\n'+(TEMPLATES/'viewer.js').read_text(encoding='utf-8')
    html=(TEMPLATES/'index.html').read_text(encoding='utf-8')
    html=html.replace('<link rel="stylesheet" href="viewer.css?access=__ACCESS__">','<style>'+(TEMPLATES/'viewer.css').read_text(encoding='utf-8')+'</style>')
    return html.replace('<script type="module" src="viewer.js?access=__ACCESS__"></script>','<script type="module">'+script+'</script>')

def assemble(job,preview_url=None):
    state=load(job)
    if preview_url is not None:
        from urllib.parse import urlsplit
        parsed=urlsplit(preview_url)
        if parsed.scheme!='https' or not parsed.hostname or parsed.username or parsed.password:
            raise ValueError('Mobile preview URL must be an HTTPS address without embedded credentials.')
        try:
            import qrcode
        except ImportError:
            raise ValueError('Mobile QR generation requires the optional qrcode package: pip install qrcode')
        qrcode.make(preview_url).save(job/'mobile-qr.png')
        state['preview_url']=preview_url
    if any(layer['status']!='imported' for layer in state['layers'].values()):raise ValueError('All four actual image-tool outputs must be imported before assembly.')
    source=Image.open(job/'source.png').convert('RGBA');warnings=[]
    lut=[round(max(0,min(1,(v-24)/207))*255) for v in range(256)]
    for kind in KINDS:
        图层路径=job/state['layers'][kind]['raw']
        if not 图层路径.is_file() or sha(图层路径)!=state['layers'][kind]['sha256']:
            raise ValueError(f'{kind} 图层文件哈希与导入记录不一致，必须重新导入并审核。')
        if kind!='structure':
            layer=Image.open(图层路径).convert('RGBA').resize(source.size,Image.Resampling.LANCZOS)
            layer.save(job/'assets'/f'{kind}.png')
            if not layer.getchannel('A').getbbox():warnings.append(kind.upper()+'_EMPTY_LAYER')
            continue
        mask=Image.open(job/'masks'/f'{kind}.png').convert('L').resize(source.size,Image.Resampling.LANCZOS).point(lut)
        character_alpha=Image.open(job/'assets/character.png').getchannel('A')
        alpha=ImageChops.multiply(character_alpha,mask)
        layer=Image.new('RGBA',source.size,'white')
        layer.putalpha(alpha);layer.save(job/'assets'/f'{kind}.png')
        if not alpha.getbbox():warnings.append(kind.upper()+'_EMPTY_SELECTION')
    (job/'index.html').write_text(html_document(job,state),encoding='utf-8')
    state['status']='assembled_unreviewed';state['assembled_at']=int(time.time()*1000);state['warnings']=warnings
    state['quality_review']={'status':'required'};save(job/'task.json',state)
    provenance={k:v for k,v in state.items() if k!='layers'}
    provenance['layers']={k:{key:value for key,value in layer.items() if key!='tool_reference'} for k,layer in state['layers'].items()}
    provenance['renderer']={'emission':40,'rgbm_range':64,'bloom_scales':[.5,.25]}
    save(job/'provenance.json',provenance)
    shutil.copyfile(TEMPLATES/'THIRD_PARTY_NOTICES.md',job/'THIRD_PARTY_NOTICES.md')
    names=['index.html','source.png',state['source']['original'],'provenance.json','prompts.json','THIRD_PARTY_NOTICES.md']
    if state.get('preview_url'):names.append('mobile-qr.png')
    names += [f'assets/{k}.png' for k in KINDS]+[f'masks/{k}.png' for k in KINDS if (job/'masks'/f'{k}.png').exists()]
    with zipfile.ZipFile(job/'card.zip','w',zipfile.ZIP_DEFLATED) as archive:
        for name in names:archive.write(job/name,name)
    return summary(job,state)

def 应用原图透明蒙版(任务目录,蒙版路径,工具引用,替换=False):
    """只使用归一化原图像素创建主体图层，禁止生成模型重绘主体。"""
    状态=load(任务目录)
    原图路径=任务目录/'source.png'
    with Image.open(原图路径) as 原图, Image.open(蒙版路径) as 蒙版图像:
        if 原图.size!=蒙版图像.size:raise ValueError('主体蒙版必须与归一化原图尺寸完全一致。')
        if 蒙版图像.mode not in ('1','L'):raise ValueError('主体蒙版必须是灰度 L 或 1 模式。')
        蒙版=蒙版图像.convert('L')
        最小值,最大值=蒙版.getextrema()
        if 最小值!=0 or 最大值!=255:raise ValueError('主体蒙版必须同时包含完全透明和完全不透明像素。')
    结果=apply_alpha(任务目录,'character',原图路径,蒙版路径,工具引用,替换)
    状态=load(任务目录);状态['layers']['character']['color_source']='normalized_source_pixels'
    状态['layers']['character']['source_sha256']=状态['source']['normalized_sha256'];save(任务目录/'task.json',状态)
    return {**结果,'character_color_source':'normalized_source_pixels'}

def 批准任务(任务目录,审核说明):
    """在完成实际视觉验收后，将已组装任务标记为完成并刷新来源记录。"""
    状态=load(任务目录)
    if 状态['status']!='assembled_unreviewed':raise ValueError('只有已组装且待审核的任务可以批准。')
    if not 审核说明.strip():raise ValueError('必须记录实际视觉审核说明。')
    状态['status']='completed';状态['completed_at']=int(time.time()*1000)
    状态['quality_review']={'status':'approved','notes':审核说明.strip()};save(任务目录/'task.json',状态)
    来源={键:值 for 键,值 in 状态.items() if 键!='layers'}
    来源['layers']={类型:{键:值 for 键,值 in 图层.items() if 键!='tool_reference'} for 类型,图层 in 状态['layers'].items()}
    来源['renderer']={'emission':40,'rgbm_range':64,'bloom_scales':[.5,.25]};save(任务目录/'provenance.json',来源)
    with zipfile.ZipFile(任务目录/'card.zip','w',zipfile.ZIP_DEFLATED) as 压缩包:
        文件名=['index.html','source.png',状态['source']['original'],'provenance.json','prompts.json','THIRD_PARTY_NOTICES.md']
        if 状态.get('preview_url'):文件名.append('mobile-qr.png')
        文件名 += [f'assets/{类型}.png' for 类型 in KINDS]+[f'masks/{类型}.png' for 类型 in KINDS if (任务目录/'masks'/f'{类型}.png').exists()]
        for 名称 in 文件名:压缩包.write(任务目录/名称,名称)
    return summary(任务目录,状态)

def apply_alpha(job,kind,color_path,mask_path,reference,replace=False):
    """Apply an independently authored selection; never derive alpha from color."""
    state=load(job)
    if state.get('layer_mode')!='direct_rgba':raise ValueError('Requires a direct_rgba job.')
    if state['layers'][kind]['status']=='imported' and not replace:raise ValueError('Layer already imported; select --replace explicitly.')
    with Image.open(color_path) as color, Image.open(mask_path) as mask_image:
        if color.width*color.height>16_000_000:raise ValueError('Color image too large.')
        if color.size!=mask_image.size:raise ValueError('Color and mask must have identical dimensions; align explicitly first.')
        if abs((color.width/color.height)/(state['source']['width']/state['source']['height'])-1)>.025:raise ValueError('Color aspect ratio differs from card canvas.')
        if mask_image.mode not in ('1','L'):raise ValueError('Selection must be an explicit grayscale L or 1 mask, not a color image.')
        mask=mask_image.convert('L')
        low,high=mask.getextrema()
        if low!=0 or high!=255:raise ValueError('Selection must contain both fully transparent and fully opaque pixels.')
        rgba=color.convert('RGBA');rgba.putalpha(mask)
        folder=job/'alpha-inputs'/kind;folder.mkdir(parents=True,exist_ok=True)
        stamp=str(time.time_ns())
        color_copy=folder/(stamp+'-color.png');mask_copy=folder/(stamp+'-mask.png');out=folder/(stamp+'-rgba.png')
        color.convert('RGBA').save(color_copy);mask.save(mask_copy);rgba.save(out)
        for name,bg in [('black','black'),('white','white')]:
            plate=Image.new('RGBA',rgba.size,bg);plate.alpha_composite(rgba);plate.convert('RGB').save(folder/(stamp+'-review-'+name+'.png'))
    result=add(job,kind,out,reference,replace)
    state=load(job);state['layers'][kind]['alpha_method']='independent_selection'
    state['layers'][kind]['alpha_inputs']={'color':str(color_copy.relative_to(job)),'color_sha256':sha(color_copy),'mask':str(mask_copy.relative_to(job)),'mask_sha256':sha(mask_copy)}
    state['layers'][kind]['visual_review']='required: alignment, edge contamination, interior holes, text residue'
    save(job/'task.json',state)
    return {**summary(job,state),'review_directory':str(folder),'visual_review':'required'}

def main():
    parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='command',required=True)
    p=sub.add_parser('prepare');p.add_argument('--source',required=True);p.add_argument('--output',required=True);p.add_argument('--name')
    p=sub.add_parser('add');p.add_argument('--job',required=True);p.add_argument('--kind',choices=KINDS,required=True);p.add_argument('--image',required=True);p.add_argument('--tool-reference');p.add_argument('--replace',action='store_true')
    p=sub.add_parser('apply-alpha');p.add_argument('--job',required=True);p.add_argument('--kind',choices=('character','ui'),required=True);p.add_argument('--color',required=True);p.add_argument('--mask',required=True);p.add_argument('--tool-reference',required=True);p.add_argument('--replace',action='store_true')
    p=sub.add_parser('apply-source-alpha');p.add_argument('--job',required=True);p.add_argument('--mask',required=True);p.add_argument('--tool-reference',required=True);p.add_argument('--replace',action='store_true')
    p=sub.add_parser('approve');p.add_argument('--job',required=True);p.add_argument('--notes',required=True)
    for command in ('assemble','status'):
        p=sub.add_parser(command);p.add_argument('--job',required=True)
        if command=='assemble':p.add_argument('--preview-url')
    args=parser.parse_args()
    if args.command=='prepare':result=prepare(Path(args.source).expanduser().resolve(),Path(args.output).expanduser().resolve(),args.name)
    else:
        job=Path(args.job).expanduser().resolve()
        if args.command=='add':result=add(job,args.kind,Path(args.image).expanduser().resolve(),args.tool_reference,args.replace)
        elif args.command=='apply-alpha':result=apply_alpha(job,args.kind,Path(args.color),Path(args.mask),args.tool_reference,args.replace)
        elif args.command=='apply-source-alpha':result=应用原图透明蒙版(job,Path(args.mask).expanduser().resolve(),args.tool_reference,args.replace)
        elif args.command=='approve':result=批准任务(job,args.notes)
        elif args.command=='assemble':result=assemble(job,args.preview_url)
        else:result=summary(job,load(job))
    print(json.dumps(result,ensure_ascii=False))

if __name__=='__main__':
    try:main()
    except (ValueError,OSError,KeyError) as error:
        print(json.dumps({'error':str(error),'api_called':False,'generation_started_by_script':False},ensure_ascii=False));sys.exit(1)
