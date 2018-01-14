#example WriteMessageToMSMQTrans "FormatName:DIRECT=OS:{_server_name_}\private$\{_queue_name_}" "<messagebody></messagebody>" "message label!"
[Reflection.Assembly]::LoadWithPartialName("System.Messaging")

function WriteMessageToMSMQTrans($queueName, $message, $label)
  {
     $queue = new-object System.Messaging.MessageQueue $queueName
     $utf8 = new-object System.Text.UTF8Encoding
     $tran = new-object System.Messaging.MessageQueueTransaction
     $tran.Begin()
     $msgBytes = $utf8.GetBytes($message)
     $msgStream = new-object System.IO.MemoryStream
     $msgStream.Write($msgBytes, 0, $msgBytes.Length)
     $msg = new-object System.Messaging.Message
     $msg.BodyStream = $msgStream   
     if ($label -ne $null)
       {
         $msg.Label = $label
       }
     $queue.Send($msg, $tran)
     $tran.Commit()
     Write-Host "Message written: " $message
  }
