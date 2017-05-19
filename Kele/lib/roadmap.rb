module Roadmap
    
    def create_submissions(checkpoint_id, assignment_branch, assignment_commit_link, comment)
     response = self.class.post(base_api_endpoint("checkpoint_submissions"), body: { "checkpoint_id": checkpoint_id, "assignment_branch": assignment_branch, "assignment_commit_link": assignment_commit_link, "comment": comment }, headers: { "authorization" => @auth_token })
     puts response
   end
    
  def get_roadmap(roadmap_id)
     response = self.class.get(base_api_endpoint("roadmaps/#{roadmap_id}"), headers: { "authorization" => @auth_token })
     @roadmap = JSON.parse(response.body)
   end
 
   def get_checkpoint(checkpoint_id)
     response = self.class.get(base_api_endpoint("checkpoints/#{checkpoint_id}"), headers: { "authorization" => @auth_token })
     @checkpoint = JSON.parse(response.body)
   end
   
   def get_messages(page=0)
     
     if page == 0
         response = self.class.get(base_api_endpoint("message_threads?page=1"), headers: { "authorization" => @auth_token })
        @get_messages = JSON.parse(response.body)
        
        count = @get_messages["count"]
        
        if count % 10 > 0
            count = count/10 + 1
        end
        
        all_Messages = []
        
        until count == 0  do
            response = self.class.get(base_api_endpoint("message_threads?page=#{count}"), headers: { "authorization" => @auth_token })
            @get_messages = JSON.parse(response.body)
            all_Messages.push(@get_messages)
            count-=1
        end
        
        return all_Messages
     else
     
     response = self.class.get(base_api_endpoint("message_threads?page=#{page}"), headers: { "authorization" => @auth_token })
     @get_messages = JSON.parse(response.body)
    end
 
   end
 
   def create_message(recipient_id, subject, message)
       
       
    response = self.class.get(base_api_endpoint("users/me"), headers: { "authorization" => @auth_token })
    @get_messages = JSON.parse(response.body)
        
    id = @get_messages["id"]
    response = self.class.post(base_api_endpoint("messages"), body: { "user_id": id, "recipient_id": recipient_id, "subject": subject, "stripped-text": message }, headers: { "authorization" => @auth_token })
    puts response
    
   end
  
end