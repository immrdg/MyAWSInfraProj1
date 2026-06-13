output "s3_bucket_id" {
  description = "The S3 bucket ID"
  value       = module.s3_bucket.bucket_id
}

output "s3_bucket_arn" {
  description = "The S3 bucket ARN"
  value       = module.s3_bucket.bucket_arn
}

output "s3_bucket_domain_name" {
  description = "The S3 bucket domain name"
  value       = module.s3_bucket.bucket_domain_name
}
