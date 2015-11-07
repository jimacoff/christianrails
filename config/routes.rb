Christianrails::Application.routes.draw do
  root 'main#index'

  get 'download', to: 'main#download_pdf'
  
end
