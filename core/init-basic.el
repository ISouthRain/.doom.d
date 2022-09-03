;;; core/init-basic.el -*- lexical-binding: t; -*-


(defun freedom-hugo-home ()
  (interactive)
  (if freedom/is-windows
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
  (if freedom/is-termux
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
  (if freedom/is-darwin
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
  (if freedom/is-linux
      (if (not freedom/is-termux)
          (find-file "~/f/Hugo/content/posts/Home.md")))
  )
(provide 'init-basic)
