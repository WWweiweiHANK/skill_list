# Host integration contract

Replace the example path below with the actual directory used for the copied component.

```ini
[autoload]
DampedSprings="*res://ui/faithful_button2d/runtime/damped_springs.gd"

[internationalization]
locale/translation_remaps={
"res://ui/faithful_button2d/fonts/main.tres": PackedStringArray("res://ui/faithful_button2d/fonts/chinese.tres:zh_CN")
}
```

`DampedSprings` is a shared service, not a child node of a button. Register it once per project. `Juice2D` creates its original `DampedSpring1D` instances through that service, preserving the source timing and spring parameters.

The source controller references the host singleton `InputManager.using_gamepad()`. Reuse the project's existing input manager if it exposes that method. If it does not, decide with the user whether to add the contract to the host service; do not replace the source controller with a local fallback.

The scene uses the `Sound` bus for `Hover` and `Click`. Add that bus to the project's default audio bus layout, or explicitly remap both players only when the user authorizes a project-wide audio-routing change.

The component uses source coordinates rather than responsive anchors: its root is a `Node2D`, with `Button` offsets from `(-90, -40.5)` to `(90, 40.5)`. Position the root from the owning screen; it is not itself a responsive menu layout.
