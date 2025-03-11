# Contributing to Terraform GCP Cloud Run Module

Thank you for your interest in contributing to the Terraform GCP Cloud Run Module! We value the contributions of each community member and want to make the process as smooth as possible.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We expect all contributors to adhere to the principles of open source collaboration.

## How to Contribute

We follow the "fork-and-pull" Git workflow:

1. **Fork the Repository**: Fork the repository to your own GitHub account.
2. **Create a Feature Branch**: Create a branch in your forked repository:
   ```
   git checkout -b feature/your-feature-name
   ```
3. **Make Your Changes**: Implement your changes, additions, or fixes.
4. **Commit Your Changes**: Make sure your commits are descriptive:
   ```
   git commit -m 'Add some feature'
   ```
5. **Push to Your Fork**:
   ```
   git push origin feature/your-feature-name
   ```
6. **Open a Pull Request**: Go to the original repository and open a pull request from your fork. Clearly describe the changes and their purpose.
7. **Code Review**: Wait for code review and address any feedback.

## Development Guidelines

### Terraform Style

- Follow the [Terraform Style Guide](https://www.terraform.io/docs/language/syntax/style.html)
- Use 2 spaces for indentation
- Format your code using `terraform fmt` before submitting
- Validate your code using `terraform validate`

### Documentation

- Update the README.md if you're adding new features or changing existing functionality
- Document all variables, outputs, and resources
- Include examples for new features
- Update the CHANGELOG.md with your changes

### Testing

- Test your changes with different configurations
- Verify that your changes work with the latest versions of Terraform and the Google provider
- Include test instructions in your pull request

## Submitting Issues

- Use the issue templates when submitting bugs or feature requests
- Provide as much detail as possible
- Include steps to reproduce for bugs
- For feature requests, explain the use case and benefits

## Pull Request Process

1. Ensure your code follows the style guidelines
2. Update the documentation with details of changes
3. Update the CHANGELOG.md with details of changes
4. The PR will be merged once it receives approval from maintainers

## Release Process

Releases are managed by the project maintainers. We follow semantic versioning:

- MAJOR version for incompatible API changes
- MINOR version for new functionality in a backwards compatible manner
- PATCH version for backwards compatible bug fixes

## Questions?

If you have any questions about contributing, please open an issue with the label "question". 