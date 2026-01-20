def update
  @post = Post.find(params[:id])

  authorize @post 

  if @post.update(post_params)
    redirect_to @post
  else
    render :edit
  end
end
