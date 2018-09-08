class BlogsController < ApplicationController
    before_action :set_blog, only: [:show, :edit, :update, :destroy]
    before_action :log_in?, only: [:new, :edit, :show, :destroy] 

    def index
        @blogs = Blog.all    
    end  
    
    def new
      if params[:back]
        @blog = Blog.new(blog_params)
      else
        @blog = Blog.new
      end
    end
    
    def confirm
        @blog = Blog.new(blog_params)
        @blog.user_id = current_user.id
        render :new if @blog.invalid?
    end
    
    def create
      @blog = Blog.new(blog_params)
      @blog.user_id = current_user.id #現在ログインしているuserのidをblogのuser_idカラムに挿入する。
      respond_to do |format|
        if @blog.save
          BlogMailer.blog_mail(@blog).deliver  ##追記
          format.html { redirect_to blogs_path(@blog), notice: 'Blog was successfully created.' }
          format.json { render :show, status: :created, location: @blog }
        else
          format.html { render :new }
          format.json { render json: @blog.errors, status: :unprocessable_entity }
        end
        
       
        @user = User.find_by(id: @blog.user_id)#9/8追加
    
    
      end
    end
    
    def edit
    end
    
    def show
        @favorite = current_user.favorites.find_by(blog_id: @blog.id)
    end
    
    def update
        if @blog.update(blog_params)
            redirect_to blogs_path, notice:"update！"
        else
            render'edit'
        end
    end
    
    def destroy
        @blog.destroy
        redirect_to blogs_path, notice:"delete！"
    end

    private
    
    def log_in?
      if current_user.blank?
        redirect_to new_session_path
      end
    end
   
    def set_blog
        @blog = Blog.find(params[:id])
    end
  
    def blog_params
        params.require(:blog).permit(:name, :email, :title, :content, :image, :image_cache, :user_id)
    end

end
