class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]
  before_action :correct_user, only: :destroy

  private

  def micropost_params
    params.require(:micropost).permit(:content, :image)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to(root_url, status: :see_other) if @micropost.nil?
  end

  public

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.image.attach(micropost_params[:image])
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to(root_url)
    else
      @feed_items = current_user.feed.paginate(page: params[:page], per_page: 10)
      render 'static_pages/home', status: :unprocessable_entity
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = 'Micropost deleted'
    redirect_back_or_to(root_url, status: :see_other)
  end
end
