import json
import subprocess


# Hyprland reports the XKB modifier mask with each binding.
MODIFIERS = ("Shift", "Caps Lock", "Ctrl", "Alt", "Mod2", "Mod3", "Meta", "Mod5")


def main():
    bindings = json.loads(subprocess.check_output(["hyprctl", "-j", "binds"]))
    shortcuts = []
    for binding in bindings:
        if not binding["description"]:
            continue

        modifiers = [
            name for bit, name in enumerate(MODIFIERS)
            if binding["modmask"] & (1 << bit)
        ]
        key = binding["key"] or f'keycode {binding["keycode"]}'
        combo = "+".join([*modifiers, key.title()])
        submap = f' ({binding["submap"]})' if binding["submap"] else ""
        shortcuts.append(f'{combo}{submap}  —  {binding["description"]}')

    subprocess.run(
        ["hyprlauncher", "--dmenu"],
        input="\n".join(shortcuts) + "\n" if shortcuts else "No described shortcuts\n",
        text=True,
        stdout=subprocess.DEVNULL,
    )


if __name__ == "__main__":
    main()
