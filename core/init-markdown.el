;;; core/init-markdown.el -*- lexical-binding: t; -*-

(after! markdown-toc
  :defer 1
  :hook (markdown-mode . markdown-toc-mode)
  :config
  (add-hook 'markdown-mode-hook #'markdown-toc-mode)
  (defun freedom-hugo-home ()
    (interactive) ; 如果不需要定义成命令，这句可以不要。
    (when (string= "gnu/linux" system-type)
      (find-file "~/Ubuntu/ubuntu-fs/root/Hugo/content/posts/Home.md"))
    (when (string= "darwin" system-type)
      (find-file "~/Desktop/Hugo/content/posts/Home.md"))
    (when (string= "windows-nt" system-type)
      (find-file "F:\\Hugo\\content\\posts\\Home.md"))
    )

  )

(provide 'init-markdown)
