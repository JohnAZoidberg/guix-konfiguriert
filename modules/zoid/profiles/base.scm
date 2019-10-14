(define-module (zoid profiles base)
 #:export (zoid-base-service-type))

(use-modules (gnu))
(use-service-modules ssh)

(define zoid-etcs
 (list `("tmux.conf" ,(local-file "../../../static/tmux.conf"))))

(define zoid-accounts
 (list (user-account
        (name "zoid")
        (comment "")
        (group "users")
        (home-directory "/home/zoid")
        (shell #~(string-append #$(specification->package "fish") "/bin/fish"))
        (supplementary-groups
         '("wheel" "netdev" "audio" "video")))))

(define zoid-pubkey
 `("zoid" ,(plain-file "zoid.pub"
                       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOOMdHkEu2Fw4WCqZPJCh64LaKhPhDTcOaH4uH87tOIw")))

(define zoid-base-service-type
 (service-type
  (name 'zoid-base)
  (extensions
   (list (service-extension account-service-type (const zoid-accounts))
         (service-extension profile-service-type (const (map specification->package '("vim"  "git" "tmux" "direnv" "ansible"))))
         (service-extension special-files-service-type
                            (const `(("/bin/sh" ,(file-append (specification->package "bash") "/bin/sh"))
                                     ("/usr/bin/env" ,(file-append coreutils "/bin/env")))))
         (service-extension openssh-service-type (const (list zoid-pubkey)))
         (service-extension etc-service-type (const zoid-etcs))))))

