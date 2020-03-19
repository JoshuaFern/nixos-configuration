{ config, pkgs, lib, ... }:
let
  name = "win10-vm"; # VM Name
  isoboot = "/var/lib/libvirt/images/server2019.iso"; # Windows Install Disk
  isoextra = "/var/lib/libvirt/images/virtio-win.iso"; # VirtIO Drivers
  disk = "/var/lib/libvirt/images/win10-vm.qcow2"; # Disk Image
in
{ imports = [ ./.. ];

  systemd.services.win10-vm = {
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
    };
    script =
      let
        xml = pkgs.writeText "libvirt-guest-${name}.xml"
          ''
            <domain type="kvm">
              <name>${name}</name>
              <uuid>3ad73119-1c27-4b2e-8dcf-afbf5b5aef54</uuid>
              <metadata>
                <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
                  <libosinfo:os id="http://microsoft.com/win/2k19"/>
                </libosinfo:libosinfo>
              </metadata>
              <memory unit="GiB">10</memory>
              <currentMemory unit="GiB">10</currentMemory>
              <vcpu placement="static">8</vcpu>
              <os>
                <type arch="x86_64" machine="pc-q35-4.2">hvm</type>
                <loader readonly="yes" type="pflash">/run/libvirt/nix-ovmf/OVMF_CODE.fd</loader>
                <nvram>/var/lib/libvirt/qemu/nvram/${name}_VARS.fd</nvram>
              </os>
              <features>
                <acpi/>
                <apic/>
                <hyperv>
                  <relaxed state="on"/>
                  <vapic state="on"/>
                  <spinlocks state="on" retries="8191"/>
                  <vendor_id state="on" value="whatever"/>
                </hyperv>
                <vmport state="off"/>
                <kvm>
                  <hidden state="on"/>
                </kvm>
              </features>
              <cpu mode="host-model" check="partial">
                <model fallback="allow"/>
              </cpu>
              <clock offset="localtime">
                <timer name="rtc" tickpolicy="catchup"/>
                <timer name="pit" tickpolicy="delay"/>
                <timer name="hpet" present="no"/>
                <timer name="hypervclock" present="yes"/>
              </clock>
              <on_poweroff>destroy</on_poweroff>
              <on_reboot>restart</on_reboot>
              <on_crash>destroy</on_crash>
              <pm>
                <suspend-to-mem enabled="no"/>
                <suspend-to-disk enabled="no"/>
              </pm>
              <devices>
                <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
                <disk type="file" device="disk">
                  <driver name="qemu" type="qcow2"/>
                  <source file="${disk}"/>
                  <target dev="vda" bus="virtio"/>
                  <boot order="2"/>
                  <address type="pci" domain="0x0000" bus="0x05" slot="0x00" function="0x0"/>
                </disk>
                <disk type="file" device="cdrom">
                  <driver name="qemu" type="raw"/>
                  <source file="${isoboot}"/>
                  <target dev="sdb" bus="sata"/>
                  <readonly/>
                  <boot order="1"/>
                  <address type="drive" controller="0" bus="0" target="0" unit="1"/>
                </disk>
                <disk type="file" device="cdrom">
                  <driver name="qemu" type="raw"/>
                  <source file="${isoextra}"/>
                  <target dev="sdc" bus="sata"/>
                  <readonly/>
                  <address type="drive" controller="0" bus="0" target="0" unit="2"/>
                </disk>
                <controller type="usb" index="0" model="qemu-xhci" ports="15">
                  <address type="pci" domain="0x0000" bus="0x02" slot="0x00" function="0x0"/>
                </controller>
                <controller type="sata" index="0">
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x1f" function="0x2"/>
                </controller>
                <controller type="pci" index="0" model="pcie-root"/>
                <controller type="virtio-serial" index="0">
                  <address type="pci" domain="0x0000" bus="0x03" slot="0x00" function="0x0"/>
                </controller>
                <controller type="pci" index="1" model="pcie-root-port">
                  <model name="pcie-root-port"/>
                  <target chassis="1" port="0x10"/>
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0" multifunction="on"/>
                </controller>
                <controller type="pci" index="2" model="pcie-root-port">
                  <model name="pcie-root-port"/>
                  <target chassis="2" port="0x11"/>
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x1"/>
                </controller>
                <controller type="pci" index="3" model="pcie-root-port">
                  <model name="pcie-root-port"/>
                  <target chassis="3" port="0x12"/>
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x2"/>
                </controller>
                <controller type="pci" index="4" model="pcie-root-port">
                  <model name="pcie-root-port"/>
                  <target chassis="4" port="0x13"/>
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x3"/>
                </controller>
                <controller type="pci" index="5" model="pcie-root-port">
                  <model name="pcie-root-port"/>
                  <target chassis="5" port="0x14"/>
                  <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x4"/>
                </controller>
                <interface type="network">
                  <mac address="52:54:00:d0:1b:02"/>
                  <source network="default"/>
                  <model type="virtio"/>
                  <address type="pci" domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
                </interface>
                <serial type="pty">
                  <target type="isa-serial" port="0">
                    <model name="isa-serial"/>
                  </target>
                </serial>
                <console type="pty">
                  <target type="serial" port="0"/>
                </console>
                <channel type="spicevmc">
                  <target type="virtio" name="com.redhat.spice.0"/>
                  <address type="virtio-serial" controller="0" bus="0" port="1"/>
                </channel>
                <input type="mouse" bus="ps2"/>
                <input type="keyboard" bus="virtio"/>
                <graphics type="spice" autoport="yes">
                  <listen type="address"/>
                  <image compression="off"/>
                </graphics>
                    <hostdev mode="subsystem" type="pci" managed="yes">
                      <source>
                        <address domain="0x0000" bus="0x01" slot="0x00" function="0x0"/>
                      </source>
                      <address type="pci" domain="0x0000" bus="0x06" slot="0x00" function="0x0"/>
                    </hostdev>
                    <hostdev mode="subsystem" type="pci" managed="yes">
                      <source>
                        <address domain="0x0000" bus="0x01" slot="0x00" function="0x1"/>
                      </source>
                      <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
                    </hostdev>
                <redirdev bus="usb" type="spicevmc">
                  <address type="usb" bus="0" port="2"/>
                </redirdev>
                <redirdev bus="usb" type="spicevmc">
                  <address type="usb" bus="0" port="3"/>
                </redirdev>
                <shmem name='looking-glass'>
                  <model type='ivshmem-plain'/>
                  <size unit='M'>32</size>
                </shmem>
                <shmem name='scream-ivshmem'>
                 <model type='ivshmem-plain'/>
                 <size unit='M'>2</size>
                 <address type='pci' domain='0x0000' bus='0x00' slot='0x11' function='0x0'/>
                </shmem>
              </devices>
            </domain>
          '';
      in
        ''
          uuid="$(${pkgs.libvirt}/bin/virsh domuuid '${name}' || true)"
          ${pkgs.libvirt}/bin/virsh define <(sed "s/UUID/$uuid/" '${xml}')
          ${pkgs.libvirt}/bin/virsh start '${name}'
        '';
    preStop =
      ''
        ${pkgs.libvirt}/bin/virsh shutdown '${name}'
        let "timeout = $(date +%s) + 10"
        while [ "$(${pkgs.libvirt}/bin/virsh list --name | grep --count '^${name}$')" -gt 0 ]; do
          if [ "$(date +%s)" -ge "$timeout" ]; then
            ${pkgs.libvirt}/bin/virsh destroy '${name}'
          else
            sleep 0.5
          fi
        done
      '';
  };
}
