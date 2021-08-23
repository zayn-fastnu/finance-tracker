class FriendshipsController < ApplicationController

  def create
    friend = Friendship.create(user_id: current_user.id, friend_id: params[:friend])
    if friend.save
      redirect_to my_friends_path, notice: "Following Friend."
    else
      redirect_to my_friends_path, alert: "Something went wrong. Please try again."
    end
  end

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    redirect_to my_friends_path, notice: "Stopped Following"
  end
  
end
