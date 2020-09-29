describe('Login', () => {
  beforeEach(() => {
    cy.appFixtures();
  });
  it('Login iuser with valid credentials', () => {
    cy.visit('/users/sign_in');

    cy.get('[name="user[email]"]').type('harry@gmail.com');
    cy.get('[name="user[password]"]').type('123456');

    cy.get('[name="commit"]')
        .contains('INGRESA')
        .click();

    cy.location('pathname').should('eq', '/');

    cy.get('.alert-success')
        .contains('Sesión iniciada')
        .should('be.visible');
  });

  it('Login iuser with invalid credentials', () => {
    cy.visit('/users/sign_in');

    cy.get('[name="user[email]"]').type('harry@gmail.com');
    cy.get('[name="user[password]"]').type('1234560');

    cy.get('[name="commit"]')
        .contains('INGRESA')
        .click();

    cy.location('pathname').should('eq', '/users/sign_in');

    cy.get('.alert-warning')
        .contains('Correo o contraseña inválidos.')
        .should('be.visible');
  });
});
