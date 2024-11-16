// H1 component
export const H1 = ({ children }: { children: React.ReactNode }) => (
  <h1 className="text-4xl font-bold">{children}</h1>
);

// H2 component
export const H2 = ({ children }: { children: React.ReactNode }) => (
  <h2 className="text-3xl font-bold">{children}</h2>
);

// H3 component
export const H3 = ({ children }: { children: React.ReactNode }) => (
  <h3 className="text-2xl font-bold">{children}</h3>
);

// P component
export const P = ({ children }: { children: React.ReactNode }) => (
  <p className="text-base">{children}</p>
);
