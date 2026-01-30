# Contributing to repo-skeletor

Thank you for your interest in repo-skeletor! This is a template repository designed to help solo developers set up a powerful workflow with AI integrations.

## Using This Template

### For Your Own Project

1. **Use this template** to create a new repository:
   - Click "Use this template" button on GitHub
   - Or clone and set up your own remote

2. **Run the setup script**:
   ```bash
   ./setup.sh
   ```

3. **Configure your secrets**:
   - Add API keys to `.env` for local development
   - Add secrets to GitHub repository settings for Actions
   - See [SECRETS.md](SECRETS.md) for detailed instructions

4. **Customize for your needs**:
   - Modify workflow files in `.github/workflows/`
   - Adjust AI configurations in `.claude/`, `.gemini/`, `.continue/`
   - Update README.md with your project details

## Improving the Template

If you'd like to contribute improvements to repo-skeletor itself:

### Suggesting Enhancements

1. Check existing issues to see if your idea has been discussed
2. Open a new issue describing:
   - What problem it solves
   - How it would work
   - Example use cases

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

### Development Guidelines

- **Keep it minimal**: This is a template, not a full application
- **Document everything**: Update README.md and SECRETS.md as needed
- **Test workflows**: Ensure GitHub Actions work correctly
- **Security first**: Never commit API keys or secrets
- **Stay generic**: Don't add project-specific code

### Adding New Integrations

When adding a new tool integration:

1. Create a new directory for configuration (e.g., `.newtool/`)
2. Add workflow file if needed (`.github/workflows/newtool-sync.yml`)
3. Update `setup.sh` to check for new secrets
4. Document in README.md and SECRETS.md
5. Add to `.env.example`

### Testing Changes

Before submitting a PR:

1. Test the setup script on a fresh clone
2. Verify GitHub Actions syntax:
   ```bash
   # Install act (GitHub Actions local runner)
   # https://github.com/nektos/act
   act -l
   ```
3. Check markdown formatting
4. Ensure all links work

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Focus on what's best for the community
- Show empathy towards others
- Accept constructive criticism gracefully

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Publishing others' private information
- Other unprofessional conduct

## Questions?

- Open an issue for bugs or feature requests
- Check existing documentation first
- Be clear and concise in your questions

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

## Acknowledgments

This template is designed to help solo developers be more productive. Contributions that maintain this focus while adding value are especially welcome.

Thank you for helping make repo-skeletor better! 🚀
