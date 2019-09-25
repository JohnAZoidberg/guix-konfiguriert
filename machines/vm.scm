;; This is an operating system configuration generated
;; by the graphical installer.

(use-modules (gnu))
(use-package-modules vim tmux version-control)
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
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (list (specification->package "i3-wm")
            (specification->package "nss-certs")
             vim tmux git)
      %base-packages))
  (services
    (append
      (list (service openssh-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout))))
      %desktop-services)))
