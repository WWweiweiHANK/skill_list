import importlib.util
import json
from pathlib import Path
import socket
import tempfile
import unittest
from unittest.mock import patch
import zipfile
from PIL import Image

spec=importlib.util.spec_from_file_location('native',Path(__file__).resolve().parents[1]/'scripts/native.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
class NativeTests(unittest.TestCase):
 def test_不含透明通道的候选必须报告可验证证据(self):
  with tempfile.TemporaryDirectory() as 文件夹:
   根目录=Path(文件夹);原图=根目录/'source.png';Image.new('RGB',(70,98),'navy').save(原图)
   候选=根目录/'fake-transparent.png';Image.new('RGB',(70,98),(204,204,204)).save(候选)
   任务=根目录/'job';native.prepare(原图,任务,None)
   结果=native.add(任务,'character',候选,'透明背景候选')
   证据=结果['transparency_evidence']
   self.assertEqual(结果['status'],'needs_alpha_mask')
   self.assertEqual(证据['classification'],'opaque-no-alpha')
   self.assertFalse(证据['has_alpha_channel'])
   self.assertEqual(证据['transparent_pixels'],0)

 def test_组装拒绝导入后被替换的图层(self):
  with tempfile.TemporaryDirectory() as 文件夹:
   根目录=Path(文件夹);原图=根目录/'source.png';Image.new('RGB',(70,98),'purple').save(原图)
   角色=根目录/'character.png';图像=Image.new('RGBA',(70,98),'white');图像.putpixel((0,0),(0,0,0,0));图像.save(角色)
   结构=根目录/'structure.png';Image.new('L',(70,98),255).save(结构)
   任务=根目录/'job';native.prepare(原图,任务,None)
   for 类型 in native.KINDS:native.add(任务,类型,结构 if 类型=='structure' else 原图 if 类型=='background' else 角色,'fixture')
   Image.new('RGBA',(70,98),(0,0,0,0)).save(任务/'raw'/'character.png')
   with self.assertRaisesRegex(ValueError,'哈希'):native.assemble(任务)

 def test_原图主体图层保留原始像素(self):
  with tempfile.TemporaryDirectory() as 文件夹:
   根目录=Path(文件夹);原图=根目录/'source.png';图像=Image.new('RGB',(70,98),(30,60,90));图像.putpixel((30,40),(7,123,231));图像.save(原图)
   蒙版=根目录/'mask.png';选择=Image.new('L',图像.size,0);选择.putpixel((30,40),255);选择.save(蒙版)
   任务=根目录/'job';native.prepare(原图,任务,None)
   native.应用原图透明蒙版(任务,蒙版,'source-preserving test')
   状态=native.load(任务);结果=Image.open(任务/状态['layers']['character']['raw'])
   self.assertEqual(结果.getpixel((30,40)),(7,123,231,255));self.assertEqual(结果.getpixel((0,0))[3],0)

 def test_组装后必须显式批准才算完成(self):
  with tempfile.TemporaryDirectory() as 文件夹:
   根目录=Path(文件夹);原图=根目录/'source.png';Image.new('RGB',(70,98),'purple').save(原图)
   角色=根目录/'character.png';图像=Image.new('RGBA',(70,98),'white');图像.putpixel((0,0),(0,0,0,0));图像.save(角色)
   结构=根目录/'structure.png';Image.new('L',(70,98),255).save(结构)
   任务=根目录/'job';native.prepare(原图,任务,None)
   for 类型 in native.KINDS:native.add(任务,类型,结构 if 类型=='structure' else 原图 if 类型=='background' else 角色,'fixture')
   结果=native.assemble(任务);self.assertEqual(结果['status'],'assembled_unreviewed');self.assertTrue(Path(结果['html']).is_file())
   结果=native.批准任务(任务,'black/white, tilt, glow and back reviewed');self.assertEqual(结果['status'],'completed')

 def test_native_build_without_api_or_network(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);source=root/'source.png';Image.new('RGBA',(70,98),(20,130,210,255)).save(source)
   mask=root/'mask.png';Image.new('L',(70,98),255).save(mask);job=root/'task';colored=root/'colored.png';im=Image.new('RGBA',(70,98),(200,40,10,128));im.putpixel((0,0),(0,0,0,0));im.save(colored)
   with patch.object(socket,'create_connection',side_effect=AssertionError('Network forbidden')):
    result=native.prepare(source,job,'Safe </script> card');self.assertEqual(result['execution'],'codex_builtin_image_gen')
    self.assertEqual(result['completed_layers'],0)
    with self.assertRaises(ValueError):native.assemble(job)
    for kind in native.KINDS:native.add(job,kind,mask if kind=='structure' else source if kind=='background' else colored,'test-local-fixture')
    result=native.assemble(job);self.assertEqual(result['status'],'assembled_unreviewed')
    result=native.批准任务(job,'fixture reviewed');self.assertEqual(result['status'],'completed')
   self.assertEqual(Image.open(job/'assets/character.png').getpixel((1,1)),(200,40,10,128))
   html=(job/'index.html').read_text(encoding='utf-8');self.assertIn('globalThis.HOLO_MANIFEST',html);self.assertIn('Safe \\u003c/script> card',html);self.assertNotIn('src="viewer.js',html)
   with zipfile.ZipFile(job/'card.zip') as archive:self.assertIsNone(archive.testzip());self.assertIn('provenance.json',archive.namelist())
 def test_background_plate_must_be_complete(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);source=root/'source.png';Image.new('RGBA',(70,98),(20,130,210,255)).save(source)
   hole=root/'hole.png';im=Image.open(source);im.putpixel((30,40),(0,0,0,0));im.save(hole)
   job=root/'task';native.prepare(source,job,None)
   with self.assertRaisesRegex(ValueError,'fully opaque'):native.add(job,'background',hole,None)
   self.assertEqual(native.load(job)['layers']['background']['error'],'BACKGROUND_HAS_HOLES')
   native.add(job,'background',source,None)
   self.assertEqual(native.load(job)['layers']['background']['status'],'imported')
 def test_independent_alpha_preserves_dark_and_light_rgb(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);color=root/'color.png';im=Image.new('RGB',(70,98),'white');im.putpixel((20,20),(0,0,0));im.save(color)
   mask=root/'mask.png';m=Image.new('L',im.size,255);m.putpixel((0,0),0);m.putpixel((1,0),128);m.save(mask)
   job=root/'job';native.prepare(color,job,None)
   native.apply_alpha(job,'character',color,mask,'local test selection')
   state=native.load(job);out=Image.open(job/state['layers']['character']['raw'])
   self.assertEqual(out.getpixel((20,20)),(0,0,0,255));self.assertEqual(out.getpixel((1,0)),(255,255,255,128));self.assertEqual(out.getpixel((0,0)),(255,255,255,0))
   self.assertEqual(state['layers']['character']['alpha_method'],'independent_selection')
   bad=root/'bad.png';Image.new('L',(10,10),255).save(bad)
   with self.assertRaisesRegex(ValueError,'identical dimensions'):native.apply_alpha(job,'ui',color,bad,'test')
 def test_opaque_layer_stages_mask_work_and_can_resume(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);color=root/'color.png';im=Image.new('RGB',(70,98),(180,180,180));im.putpixel((30,40),(255,255,255));im.putpixel((31,40),(0,0,0));im.save(color)
   job=root/'job';native.prepare(color,job,None)
   result=native.add(job,'character',color,'actual image output')
   self.assertEqual(result['status'],'needs_alpha_mask');self.assertEqual(result['completed_layers'],0)
   state=native.load(job);self.assertIsNone(state['layers']['character']['error'])
   self.assertTrue(Path(result['repair_input']).is_file())
   with self.assertRaises(ValueError):native.assemble(job)
   mask=root/'selection.png';m=Image.new('L',(70,98),0);m.putpixel((30,40),255);m.putpixel((31,40),255);m.save(mask)
   native.apply_alpha(job,'character',color,mask,'local spatial selection')
   state=native.load(job);self.assertEqual(state['layers']['character']['status'],'imported')
   out=Image.open(job/state['layers']['character']['raw'])
   self.assertEqual(out.getpixel((0,0))[3],0);self.assertEqual(out.getpixel((30,40)),(255,255,255,255));self.assertEqual(out.getpixel((31,40)),(0,0,0,255))
 def test_mismatched_mask_preserved_for_review(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);source=root/'source.png';Image.new('RGB',(70,98)).save(source);mask=root/'mask.png';Image.new('L',(100,100),255).save(mask)
   native.prepare(source,root/'task',None)
   with self.assertRaisesRegex(ValueError,'aspect ratio'):native.add(root/'task','structure',mask,None)
   state=native.load(root/'task');self.assertEqual(state['status'],'needs_review');self.assertTrue((root/'task'/state['layers']['structure']['raw']).is_file())
 def test_resume_refreshes_prompts_without_changing_generation_evidence(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);source=root/'source.png';Image.new('RGB',(70,98),'purple').save(source)
   job=root/'job';native.prepare(source,job,None);native.add(job,'background',source,'real-generation-reference')
   before=native.load(job)['layers'];raw=(job/'raw/background.png').read_bytes()
   (job/'prompts.json').write_text('{"background":"stale instructions"}')
   state=native.load(job)
   self.assertEqual(json.loads((job/'prompts.json').read_text()),native.current_prompts())
   self.assertEqual(state['layers'],before);self.assertEqual((job/'raw/background.png').read_bytes(),raw)
   native.add(job,'background',job/'raw/background.png','reviewed same file',replace=True)
 def test_legacy_native_job_cannot_silently_assemble(self):
  with tempfile.TemporaryDirectory() as folder:
   job=Path(folder);(job/'task.json').write_text(json.dumps({'version':1,'layers':{}}))
   with self.assertRaisesRegex(ValueError,'Obsolete native mask job'):native.assemble(job)
 def test_structure_uses_repaired_character_alpha(self):
  with tempfile.TemporaryDirectory() as folder:
   root=Path(folder);source=root/'source.png';Image.new('RGB',(70,98),'purple').save(source)
   character=root/'character.png';im=Image.new('RGBA',(70,98),'white');im.putpixel((10,10),(255,255,255,0));im.save(character)
   structure=root/'structure.png';Image.new('L',(70,98),255).save(structure)
   job=root/'job';native.prepare(source,job,None)
   for kind in native.KINDS:native.add(job,kind,structure if kind=='structure' else source if kind=='background' else character,'fixture')
   native.assemble(job);alpha=Image.open(job/'assets/structure.png').getchannel('A')
   self.assertEqual(alpha.getpixel((10,10)),0);self.assertEqual(alpha.getpixel((11,10)),255)
if __name__=='__main__':unittest.main()
