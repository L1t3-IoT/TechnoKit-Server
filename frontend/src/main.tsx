import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import '@fontsource/inter/400.css';
import '@fontsource/inter/600.css';
import '@fontsource/inter/700.css';
import '@fontsource/inter/800.css';
import App from './App';
import { BuildProvider } from './state/build';
import { AuthProvider } from './state/auth';
import './styles.css';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <BrowserRouter>
      <AuthProvider>
        <BuildProvider>
          <App />
        </BuildProvider>
      </AuthProvider>
    </BrowserRouter>
  </StrictMode>,
);
