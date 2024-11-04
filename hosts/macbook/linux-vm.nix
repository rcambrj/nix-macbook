{ flake, lib, modulesPath, pkgs, ... }:
with lib;
with flake.lib;
let
  workingDirectory = "/Users/${macbook.main-user}/.linux-vm";
  diskImage = "${workingDirectory}/disk.qcow2";
  agenixIdentityPath = "${workingDirectory}/agenix-identity";
  vmSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] pkgs.stdenv.hostPlatform.system;

  # TODO: remove dependency on UTM aarch64 firmware edk2-aarch64-code.fd
  start-linux-vm = pkgs.writeShellScriptBin "start-linux-vm" ''
    ${pkgs.qemu}/bin/qemu-system-aarch64 \
      -device virtio-gpu-pci \
      -cpu host \
      -smp cpus=10,sockets=1,cores=10,threads=1 \
      -machine virt,gic-version=3 \
      -accel hvf \
      -m 4096 \
      -device intel-hda \
      -device nec-usb-xhci,id=usb-bus \
      -device usb-tablet,bus=usb-bus.0 \
      -device usb-mouse,bus=usb-bus.0 \
      -device usb-kbd,bus=usb-bus.0 \
      -device qemu-xhci,id=usb-controller-0 \
      -device virtio-9p-pci,fsdev=virtfs0,mount_tag=projects \
      -fsdev local,id=virtfs0,path=/Users/${macbook.main-user}/projects,security_model=mapped-xattr \
      -device virtio-9p-pci,fsdev=virtfs1,mount_tag=agenix \
      -fsdev local,id=virtfs1,path=${agenixIdentityPath},security_model=mapped-xattr \
      -device virtio-blk-pci,drive=drive7E789365-AB50-4E8C-9A29-E59C6971BB8E,bootindex=0 \
      -drive if=none,media=disk,id=drive7E789365-AB50-4E8C-9A29-E59C6971BB8E,file="${diskImage}",discard=unmap,detect-zeroes=unmap \
      -name vm \
      -device virtio-rng-pci \
      -net nic,netdev=user.0,model=virtio -netdev user,id=user.0,hostfwd=tcp:127.0.0.1:2222-:22,"" \
      -drive if=pflash,format=raw,unit=0,file=/Applications/UTM.app/Contents/Resources/qemu/edk2-aarch64-code.fd,readonly=on \
      $@
  '';
in {
  environment.systemPackages = [
    start-linux-vm
  ];

  age.secrets.macbook-linux-vm-ssh-key.path = "${agenixIdentityPath}/id_ed25519";
  age.secrets.macbook-linux-vm-ssh-key.symlink = false;
  age.secrets.macbook-linux-vm-ssh-key.owner = macbook.main-user;

  launchd.user.agents.linux-vm = {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path \"${pkgs.lib.getExe start-linux-vm}\" &amp;&amp; exec \"${pkgs.lib.getExe start-linux-vm}\" -nographic"
      ];
      UserName = macbook.main-user;
      RunAtLoad = true;
      StandardOutPath = builtins.toPath "${workingDirectory}/stdout.log";
      StandardErrorPath = builtins.toPath "${workingDirectory}/stderr.log";
      KeepAlive = true;
    };
  };
}