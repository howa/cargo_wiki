module CargoWiki
  class ApplicationController < ActionController::Base
    private

    def signed_in?
      current_user.nil? ? false : true
    end
    helper_method :signed_in?

    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user

    def markdown(text)
      renderer = Redcarpet::Render::XHTML.new(:hard_wrap => true)
      markdown = Redcarpet::Markdown.new(
        renderer,
        :no_intra_emphasis => true,
        :tables => true,
        :autolink => true,
        :space_after_headers => true,
        :fenced_code_blocks => true
      )
      markdown.render(text).html_safe
    end
    helper_method :markdown

    def require_login
      unless signed_in?
        flash.alert = "You must be logged in to access this page"
        redirect_to login_path
      end
    end

    def require_admin
      unless current_user.admin?
        flash.alert = "You do not have the permissions to access this page"
        redirect_to root_path
      end
    end
  end
end
