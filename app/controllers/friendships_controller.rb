class FriendshipsController < ApplicationController
  def create
    friend = Friendship.create(user_id: current_user.id, friend_id: params[:friend])
    if friend.save
      flash[:notice] = "Following friend"
    else
      flash[:alert] = "Something went wrong. Please try again."
    end
    redirect_to my_friends_path
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    flash[:notice] = "Stopped following"
    redirect_to my_friends_path
  end
end
