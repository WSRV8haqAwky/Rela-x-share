class PostRelaxesController < ApplicationController

  def new
    @post_relax = PostRelax.new
  end

  def create
    @post_relax = PostRelax.new(post_relax_params)
    tag_names = params[:post_relax][:tag_names]
    @post_relax.user_id = current_user.id
    if @post_relax.save
       if tag_names.present?
        tags = tag_names.split("\n").map(&:strip).uniq
        create_or_update_post_relax_tags(@post_relax, tags)
       end
      redirect_to post_relax_path(@post_relax.id),
      notice: "投稿に成功しました"
    else
      render :new
    end
  end

  def index
    if params[:latest]
      @post_relaxes = PostRelax.page(params[:page]).latest
    elsif params[:old]
      @post_relaxes = PostRelax.page(params[:page]).old
    elsif params[:order_by_favorite_count]
      @post_relaxes = PostRelax.page(params[:page]).order_by_favorite_count
    elsif params[:reverse_order_by_favorite_count]
      @post_relaxes = PostRelax.page(params[:page]).reverse_order_by_favorite_count
    else
      @post_relaxes = PostRelax.page(params[:page]).reverse_order
    end
    @user = current_user
  end

  def show
    @post_relax = PostRelax.find(params[:id])
    @post_comment = PostComment.new
    @user = @post_relax.user
  end

  def edit
    @post_relax = PostRelax.find(params[:id])
    if @post_relax.user_id != current_user.id
      redirect_to post_relaxes_path
    end
  end

  def update
    @post_relax = PostRelax.find(params[:id])
    tag_names = params[:post_relax][:tag_names]

      if tag_names.present?
        tags = params[:post_relax][:tag_names].split("\n").map(&:strip).uniq
        create_or_update_post_relax_tags(@post_relax, tags)
      end
    if @post_relax.update(post_relax_params)
      redirect_to post_relax_path(@post_relax.id),
      notice: "投稿内容の更新に成功しました"
    else
      render :edit
    end
  end

  def destroy
    @post_relax = PostRelax.find(params[:id])
    @post_relax.destroy
    redirect_to post_relaxes_path
  end

  private

  def post_relax_params
    params.require(:post_relax).permit(:image, :caption)
  end

  def create_or_update_post_relax_tags(post_relax, tags)
    post_relax.tags.destroy_all
    begin
    tags.each do |tag|
      tag = Tag.find_or_create_by(name: tag)
      post_relax.tags << tag
      rescue ActiveRecord::RecordInvalid
        false
      end
    end
  end
end
