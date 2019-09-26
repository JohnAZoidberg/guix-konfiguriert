;(add-to-load-path "/home/zoid/guix-konfiguriert/modules/")
(use-modules (gnu)
             ((zoid profiles gui) #:prefix zoid:)
             ((zoid profiles base) #:prefix zoid:))
(use-package-modules shells)
(use-service-modules desktop networking ssh xorg)

(operating-system
  (locale "en_GB.utf8")
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
              (uuid "700a19a4-bcc3-4055-9b98-ec1e59315a36"))
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
  (users (cons* (user-account
                  (name "zoid")
                  (comment "Daniel Schaefer")
                  (group "users")
                  (home-directory "/home/zoid")
                  (shell #~(string-append #$fish "/bin/fish"))
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (map specification->package
        (append
           (list "nss-certs"
                 "ansible")
           zoid:gui-packages
           zoid:base-packages))
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services)))
