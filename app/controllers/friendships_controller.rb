class FriendshipsController < ApplicationController

  def create
    friend = Friendship.create(user_id: current_user.id, friend_id: params[:friend])
    if friend.save
      redirect_to my_friends_path, notice: "Following #{ get_name_of_friend(params[:friend]) }"
    else
      redirect_to my_friends_path, alert: "Something went wrong. Please try again."
    end
  end

  def get_name_of_friend(id)
    x = User.ransack(id_eq: id).result
    x.first.full_name
  end 

  def destroy
    friendship = current_user.friendships.where(friend_id: params[:id]).first
    friendship.destroy
    redirect_to my_friends_path, notice: "Stopped following #{ get_name_of_friend(params[:id]) }"
  end
  
end
