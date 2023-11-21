const testSetup = require('../__shared__/test-setup');
import { render, screen } from '@testing-library/react';
import App from './App';

test('renders learn react link', () => {
  render(<App />);
  const linkElement = screen.getByText(/learn react/i);
  expect(linkElement).toBeInTheDocument();
});

test('Ignores node_modules when detecting TypeScript', async () => {
  await testSetup.scripts.build();
  expect(fs.existsSync(tsConfigPath)).toBe(false);
});
