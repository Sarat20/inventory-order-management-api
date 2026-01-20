def update
  @post = Post.find(params[:id])

  authorize @post 
  def index
      @posts = policy_scope(Post)
  end

  if @post.update(post_params)
    redirect_to @post
  else
    render :edit
  end
end
