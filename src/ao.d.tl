global record ao
  id: string
  send: function
  record env
    record Module
      id: string
    end
    record Process
      Tags: { string: string }
      Owner: string
    end
  end
end

global record Handlers
  add: function
  record utils
    hasMatchingTag: function
  end
end

global record Message
  From: string
  Target: string
  Tags: { string: string }
  Data: string
  Owner: string
end

global record json
  encode: function
  decode: function
end