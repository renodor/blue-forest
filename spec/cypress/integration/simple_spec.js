// describe('My First Test', function() {
//   it('visit root', function() {
//     // This calls to the backend to prepare the application state
//     cy.appFixtures();

//     // Visit the application under test
//     cy.visit('/users/sign_in');

//     cy.contains('Envíos gratuitos en ordenes sobre $65.00');
//   });
// });


describe('Sign in', () => {
  it('signs in user with valid credentials', () => {
    cy.appFixtures();

    cy.visit('/users/sign_in');

    cy.get('[name="user[email]"]').type('harry@gmail.com');
    cy.get('[name="user[password]"]').type('123456');

    cy.get('[name="commit"]')
        .contains('INGRESA')
        .click();

    cy.get('.flash.success')
        .contains('Logged in')
        .should('be.visible');
  });
});
