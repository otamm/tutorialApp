module UsersHelper
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase) #gravatar uses MD5 hashing encryption, available in the default 'Digest' ruby library.
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}" #will return the specific gravatar associated with the encrypted email.
    image_tag(gravatar_url, alt: user.name, class: "gravatar") #creates an image tag in HTML which alt="user.name" and a class="gravatar"
  end
end
