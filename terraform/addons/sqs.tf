resource "aws_sqs_queue" "ecommerce_queue" {
  name                      = "ecommerce-orders-queue"
  delay_seconds             = 0
  max_message_size          = 262144 # 256 KB standard max payload
  message_retention_seconds = 86400  # Messages survive for 1 day if not processed
  receive_wait_time_seconds = 10     # Enables Long Polling to save on API call costs

  tags = {
    Environment = "dev"
    Project     = "ecommerce-gitops"
  }
}

# Output the URL so you can copy-paste it into your manifests
output "sqs_queue_url" {
  value       = aws_sqs_queue.ecommerce_queue.id
  description = "The URL for your KEDA ScaledObject queueURL field"
}