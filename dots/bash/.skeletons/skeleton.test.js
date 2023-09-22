import { deposit } from './bank-account';

// Given ...
describe('The balance is 1.000 €', () => {
  const bankAccount = {};

  beforeEach(() => {
    bankAccount.balance = 1000;
  });

  // And ...
  describe('The account is locked', () => {

    // When ...
    test('Making a deposit of 100 €', async () => {
      const amount = 100;
      const theBalance = deposit({ amount, bankAccount });
      // Then I ...
      expect(theBalance).toBe(1100);
    });

  })
});
