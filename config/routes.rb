Rails.application.routes.draw do

	devise_for :users

	devise_scope :user do
		authenticated :user do
			root 'dashboard#index', as: :authenticated_root
		end

		unauthenticated do
			root 'devise/sessions#new', as: :unauthenticated_root
		end
	end

	resources :users
	resources :dashboard do
		get 'super_admin',							on: :collection
		get 'organization_super_admin',				on: :collection
		get 'organization_dept_admin',				on: :collection
		get 'organization_editors',					on: :collection
		get 'organization_reviewers',				on: :collection
		get 'organization_students',				on: :collection
		get 'activate_organization',				on: :collection
		get 'reject_organization',					on: :collection
		get 'org_join_request',						on: :collection
		get 'approve_org_user',						on: :collection
		get 'reject_org_user',						on: :collection
		get 'dept_join_request',					on: :collection
		get 'approve_dept_user',					on: :collection
		get 'reject_dept_user',						on: :collection
		get 'forward_for_review',					on: :collection
		get 'reviewer_accepted',					on: :collection
		get 'reviewer_rejected',					on: :collection

	end
	resources :organizations
	resources :departments do
		get 'change_admin',							on: :collection
		patch 'update_admin',						on: :collection
	end

  	resources :user_posts do
  	end

  	resources :editor
	resources :reviewer

	if Rails.env.development?
		mount LetterOpenerWeb::Engine, at: "/letter_opener"
	end
end
