{ flake, lib, modulesPath, pkgs, ... }:
with lib;
with flake.lib;
let
  # vm = flake.nixosConfigurations.vm;
  # diskImageInStore = vm.config.system.build.image;
  workingDirectory = "/Users/${macbook.main-user}/.linux-vm";
  diskImage = "${workingDirectory}/disk.qcow2";
  agenixIdentityPath = "${workingDirectory}/agenix-identity";
  vmSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] pkgs.stdenv.hostPlatform.system;

  # NIX_DISK_IMAGE=$(readlink -f "''${NIX_DISK_IMAGE:-${toString diskImage}}") || test -z "$NIX_DISK_IMAGE"

  # if test -n "$NIX_DISK_IMAGE" && ! test -e "$NIX_DISK_IMAGE"; then
  #   ${pkgs.qemu}/bin/qemu-img create \
  #     -f qcow2 \
  #     -b ${diskImageInStore}/nixos.qcow2 \
  #     -F qcow2 \
  #     "$NIX_DISK_IMAGE"
  # fi
  start-linux-vm = pkgs.writeShellScriptBin "start-linux-vm" ''
    ${pkgs.qemu}/bin/qemu-system-aarch64 \
      -machine virt,gic-version=2,accel=hvf:tcg \
      -cpu max \
      -name vm \
      -m 4096 \
      -smp 1 \
      -device virtio-rng-pci \
      -device virtio-keyboard \
      -device virtio-gpu-pci \
      -device usb-ehci,id=usb0 \
      -device usb-kbd \
      -device usb-tablet \
      -net nic,netdev=user.0,model=virtio -netdev user,id=user.0,hostfwd=tcp:127.0.0.1:2222-:22,"$QEMU_NET_OPTS" \
      -drive cache=writeback,file="${diskImage}",id=drive1,if=none,index=1,werror=report \
      -device virtio-blk-pci,bootindex=1,drive=drive1,serial=root \
      $@
  '';
      # -kernel ${vm.config.system.build.toplevel}/kernel \
      # -initrd ${vm.config.system.build.initialRamdisk}/${vm.config.system.boot.loader.initrdFile} \
      # -append "$(cat ${vm.config.system.build.toplevel}/kernel-params) init=${vm.config.system.build.toplevel}/init" \
in {
  environment.systemPackages = [
    start-linux-vm
  ];

  age.secrets.macbook-linux-vm-ssh-key.path = "${agenixIdentityPath}/id_ed25519";
  age.secrets.macbook-linux-vm-ssh-key.symlink = false;
  age.secrets.macbook-linux-vm-ssh-key.owner = macbook.main-user;

  # launchd.user.agents.linux-vm = {
  #   serviceConfig = {
  #     ProgramArguments = [
  #       "/bin/sh"
  #       "-c"
  #       "/bin/wait4path \"${pkgs.lib.getExe start-linux-vm}\" &amp;&amp; exec \"${pkgs.lib.getExe start-linux-vm}\""
  #     ];
  #     UserName = macbook.main-user;
  #     RunAtLoad = true;
  #     StandardOutPath = builtins.toPath "${workingDirectory}/stdout.log";
  #     StandardErrorPath = builtins.toPath "${workingDirectory}/stderr.log";
  #     KeepAlive = true;
  #   };
  # };
}