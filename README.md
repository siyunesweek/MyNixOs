# MyNixOs
My Nix config on my personal computer

TIPS para mi

# Ver lo que tienes
sudo nix-env -p /nix/var/nix/profiles/system --list-generations

# Borrar todas menos la actual
sudo nix-env -p /nix/var/nix/profiles/system --delete-generations old

# Liberar el espacio del store
sudo nix-collect-garbage -d

# Regenerar las entradas del menú de arranque
sudo nixos-rebuild boot

# Para ahorro de energia 
asusctl profile -l          # lista perfiles: Balanced, Performance, Quiet
asusctl profile -P Quiet    # cambia a modo silencioso/ahorro
asusctl profile -p          # muestra el perfil activo
