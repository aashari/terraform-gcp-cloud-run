# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-03-11

### Added
- Support for custom domain mapping
- Health checks (startup and liveness probes)
- VPC connector support
- Configurable scaling parameters (min/max instances)
- Additional service and template annotations
- Comprehensive documentation and examples

### Changed
- Updated Google provider version to 6.24.0
- Improved resource allocation defaults
- Enhanced IAM handling with more flexible options

### Fixed
- Fixed container port type (changed from string to number)
- Fixed container concurrency type (changed from string to number)

## [1.0.0] - 2025-03-01

### Added
- Initial release
- Basic Cloud Run service deployment
- Service account creation
- IAM bindings
- Environment variables support 