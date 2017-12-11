class OrgNotificationMailer < ApplicationMailer
	require 'mail'

	def organization_created_notification(org_name, admin_email, admin_pass)
		@new_password = admin_pass
		@to_email = admin_email
		@org_name = org_name

		mail(to: @to_email,reply_to: @to_email, subject: "#{@org_name} has been created successfully!")do |format|
      		format.html { render :layout => false }
    	end
	end
end
