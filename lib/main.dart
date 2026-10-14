import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Budget Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const BudgetHomePage(),
    );
  }
}

class BudgetHomePage extends StatefulWidget {
  const BudgetHomePage({super.key});

  @override
  State<BudgetHomePage> createState() => _BudgetHomePageState();
}

class _BudgetHomePageState extends State<BudgetHomePage> {
  final TextEditingController incomeController = TextEditingController();

  final TextEditingController expenseController = TextEditingController();

  double income = 0;
  double expenses = 0;
  double balance = 0;

  bool calculated = false;

  void calculateBudget() {
    final double? enteredIncome = double.tryParse(incomeController.text.trim());

    final double? enteredExpenses = double.tryParse(
      expenseController.text.trim(),
    );

    if (enteredIncome == null ||
        enteredExpenses == null ||
        enteredIncome < 0 ||
        enteredExpenses < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid, non-negative amounts.'),
        ),
      );
      return;
    }

    setState(() {
      income = enteredIncome;
      expenses = enteredExpenses;
      balance = income - expenses;
      calculated = true;
    });
  }

  String get financialStatus {
    if (balance > 0) {
      return 'Savings Available';
    } else if (balance == 0) {
      return 'Budget Balanced';
    } else {
      return 'Over Budget';
    }
  }

  Color get statusColor {
    if (balance > 0) {
      return Colors.green;
    } else if (balance == 0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    incomeController.dispose();
    expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Budget Calculator'),
        centerTitle: true,
        backgroundColor: Colors.green.shade100,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 75,
              color: Colors.green,
            ),

            const SizedBox(height: 12),

            const Text(
              'Manage Your Budget',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 25),

            TextField(
              controller: incomeController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Monthly Income (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: expenseController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Total Expenses (₹)',
                prefixIcon: Icon(Icons.money_off),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: calculateBudget,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate Budget'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 25),

            if (calculated)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Budget Summary',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      summaryRow('Monthly Income', income),

                      const SizedBox(height: 12),

                      summaryRow('Total Expenses', expenses),

                      const Divider(height: 30),

                      summaryRow(
                        'Remaining Balance',
                        balance,
                        bold: true,
                        color: statusColor,
                      ),

                      const SizedBox(height: 20),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: statusColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          financialStatus,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Text(
                'Enter your income and expenses, '
                'then calculate your budget.',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  Widget summaryRow(
    String label,
    double amount, {
    bool bold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: bold ? 18 : 16,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color,
          ),
        ),
      ],
    );
  }
}
