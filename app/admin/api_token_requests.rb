ActiveAdmin.register ApiTokenRequest do

  permit_params :user_id, :note, :admin_note, :status

  controller do
    skip_power_check

    def scoped_collection
      ApiTokenRequest.includes(:api_token, :user)
    end
  end


  member_action :approve, method: :patch do
    resource.update(status: :approved)
    redirect_to request.referrer
  end

  member_action :reject, method: :patch do
    resource.api_token.destroy if resource.api_token.present?
    if resource.update(status: :rejected, admin_note: params[:admin_note])
      render json: {success: true}
    else
      render json: {success: false}, status: :unprocessable_entity
    end
  end

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :note
    column :admin_note
    column :api_token do |req|
      req.api_token&.uuid
    end
    column :created_at
    column :updated_at
    column :actions do |api_token_request|
      span link_to "View", admin_api_token_request_path(api_token_request)
      span link_to "Edit", edit_admin_api_token_request_path(api_token_request)
      span link_to "Delete", admin_api_token_request_path(api_token_request), method: :delete
      (span link_to "Approve", approve_admin_api_token_request_path(api_token_request), method: :patch) unless api_token_request.approved?
      (span link_to (api_token_request.approved? ? 'Revoke' : "Reject"), '#', class: 'add-note-link', 'data-api-token-request-id': api_token_request.id, 'data-admin-note': api_token_request.admin_note) unless api_token_request.rejected?
    end
  end

  form do |f|
    f.inputs do
      f.input :user_id
      f.input :status
      f.input :note
      f.input :admin_note
    end
    f.actions
  end

  show do
    attributes_table do
      row :status
      row :user
      row :note
      row :admin_note
      row :api_token do |req|
        req.api_token&.uuid
      end
      row :created_at
      row :updated_at
      row :approve do |req|
        if req.approved?
          "Already Approved"
        else
          link_to "Approve", approve_admin_api_token_request_path(req), method: :patch
        end
      end
      row 'Reject / Revoke' do |req|
        if req.rejected?
          "Already Rejected / Revoked"
        else
          link_to (api_token_request.approved? ? 'Revoke' : "Reject"),'#', class: 'add-note-link', 'data-api-token-request-id': api_token_request.id, 'data-admin-note': api_token_request.admin_note
        end
      end

    end
  end

end
