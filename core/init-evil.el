;;; core/init-evil.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; evil-collection
(use-package! evil-collection
  :config
  (defun freedom-evil-collection-nov-setup ()
    "Set up `evil' bindings for `nov'."
    (evil-collection-define-key 'normal 'nov-mode-map
      "gr" 'nov-render-document
      "s" 'nov-view-source
      "S" 'nov-view-content-source
      "g?" 'nov-display-metadata
      "gn" 'nov-next-document
      (kbd "C-j") 'nov-next-document
      (kbd "M-j") 'nov-next-document
      "]]" 'nov-next-document
      "gp" 'nov-previous-document
      (kbd "C-k") 'nov-previous-document
      (kbd "M-k") 'nov-previous-document
      "gk" 'nov-scroll-down
      "gj" 'nov-scroll-up
      "[[" 'nov-previous-document

      "t" 'nov-goto-toc
      "i" 'nov-goto-toc
      (kbd "RET") 'nov-browse-url
      (kbd "<follow-link>") 'mouse-face
      (kbd "<mouse-2>") 'nov-browse-url
      (kbd "TAB") 'shr-next-link
      (kbd "M-TAB") 'shr-previous-link
      (kbd "<backtab>") 'shr-previous-link
      (kbd "SPC") 'nov-scroll-up
      (kbd "S-SPC") 'nov-scroll-down
      (kbd "DEL") 'nov-scroll-down))
  (advice-add #'evil-collection-nov-setup :override #'freedom-evil-collection-nov-setup)
  )

(provide 'init-evil)
