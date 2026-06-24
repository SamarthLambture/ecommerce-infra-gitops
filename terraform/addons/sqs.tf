resource "aws_sqs_queue" "ecommerce_queue" {
  name                      = "ecommerce-orders-queue"
  delay_seconds             = 0
  max_message_size          = 262144 
  message_retention_seconds = 86400  
  receive_wait_time_seconds = 10     

  tags = {
    Environment = "dev"
    Project     = "ecommerce-gitops"
  }
}

output "sqs_queue_url" {
  value       = aws_sqs_queue.ecommerce_queue.id
  description = "The URL for your KEDA ScaledObject queueURL field"
}