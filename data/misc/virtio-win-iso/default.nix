{ lib, fetchurl }:

let
  pname = "virtio-win";
  version = "0.1.171-1";
in fetchurl {
  name = "${pname}-${version}";
  url = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/${pname}-${version}/${pname}.iso";

  downloadToTemp = true;
  recursiveHash = true;
  postFetch = ''
    install -D $downloadedFile $out/var/lib/libvirt/virtio-win.iso
  '';

  sha256 = "11gdjsvqk08rzg314jg9nblgy5rzi9aclg7klzwnppfnsn21938y";

  meta = with lib; {
    platforms = platforms.all;
  };
}
