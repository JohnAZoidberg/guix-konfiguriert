(add-to-load-path "modules")
(use-modules (gnu)
             (zoid profiles base)
             (zoid profiles gui))
(use-service-modules networking)

(operating-system
  (locale "en_US.utf8")
  (timezone "Europe/Berlin")
  (keyboard-layout (keyboard-layout "us" "mac"))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (target "/dev/sda")
    (keyboard-layout keyboard-layout)))
  (mapped-devices
   (list (mapped-device
          (source
           (uuid "eecea395-71c7-4aca-a99a-688466db6fe9"))
          (target "cryptroot")
          (type luks-device-mapping))))
  (file-systems
   (cons* (file-system
            (mount-point "/")
            (device "/dev/mapper/cryptroot")
            (type "ext4")
            (dependencies mapped-devices))
          %base-file-systems))
  (host-name "guix-vm")
  (users %base-user-accounts)
  (packages
   (append
    (map specification->package
         (list "nss-certs"))
    %base-packages))
  (services
   (append
    (list (service zoid-base-service-type '())
          (service zoid-gui-service-type '())
          (service dhcp-client-service-type))
    %base-services)))
