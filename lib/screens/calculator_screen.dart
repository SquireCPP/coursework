import 'package:flutter/material.dart';
import 'package:cursach2/database_helper.dart';  // Import DatabaseHelper to interact with the database
import 'history_screen.dart';  // Make sure you have this screen
import 'delete_account_screen.dart';  // Import the Delete Account screen
import 'package:expressions/expressions.dart'; // Import expressions package to handle calculation

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = '';
  String _result = '';
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Basic calculation methods
  void _appendToInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void _calculateResult() {
    try {
      final result = _evaluateExpression(_input);
      setState(() {
        _result = result;
      });
      // Save the calculation history to the database
      _databaseHelper.insertHistory('$_input = $_result');
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  String _evaluateExpression(String expression) {
    // Use the expressions package to evaluate the expression string
    final exp = Expression.parse(expression);
    final evaluator = ExpressionEvaluator();
    final result = evaluator.eval(exp, {});

    if (result == null) {
      throw Exception('Invalid Expression');
    }

    // Return the result as a string
    return result.toString();
  }

  void _clearInput() {
    setState(() {
      _input = '';
      _result = '';
    });
  }

  void _viewHistory() async {
    List<String> history = await _databaseHelper.getHistory();
    if (history.isEmpty) {
      // Show message if there is no history
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No calculation history found.')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HistoryScreen(history: history),
        ),
      );
    }
  }

  // Function to delete the user and navigate to the login screen
  void _deleteAccount() async {
    // Assuming we have userId stored in some form (e.g., SharedPreferences, Database)
    // For now, I'm using a dummy userId here (replace this with actual userId logic)
    int userId = 1; // Replace with actual user ID logic
    try {
      await _databaseHelper.deleteUser(userId); // Delete user from DB
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Account deleted successfully.')),
      );
      // After deletion, navigate to the login screen
      Navigator.pushReplacementNamed(context, '/login'); // Navigate to Login screen
    } catch (e) {
      // Handle any errors, such as database issues
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting account: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        actions: [
          // Row to include both "History" and "Delete Account" buttons
          Row(
            children: [
              // History button
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: _viewHistory, // Navigate to history screen
              ),
              // Delete Account button
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: _deleteAccount, // Call the delete account function
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display input
            TextField(
              controller: TextEditingController()..text = _input,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Input',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            // Display result
            Text(
              _result,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Calculator buttons
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              shrinkWrap: true,
              itemCount: 16,
              itemBuilder: (context, index) {
                final buttonLabels = [
                  '7', '8', '9', '/',
                  '4', '5', '6', '*',
                  '1', '2', '3', '-',
                  '0', '.', '=', '+'
                ];
                final label = buttonLabels[index];

                return ElevatedButton(
                  onPressed: () {
                    if (label == '=') {
                      _calculateResult();
                    } else if (label == 'C') {
                      _clearInput();
                    } else {
                      _appendToInput(label);
                    }
                  },
                  child: Text(label, style: const TextStyle(fontSize: 20)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
