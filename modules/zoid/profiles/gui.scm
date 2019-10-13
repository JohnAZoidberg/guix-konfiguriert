(define-module (zoid profiles gui)
 #:export (zoid-gui-service-type))

(use-modules (gnu))

(define gui-packages
 (map specification->package
      '("i3-wm"
      "xfce4-terminal"
      "xcape")))

(define zoid-gui-service-type
 (service-type
  (name 'zoid-gui)
  (extensions
   (list (service-extension profile-service-type (const gui-packages))))))

