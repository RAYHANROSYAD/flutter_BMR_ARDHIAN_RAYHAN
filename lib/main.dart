import 'package:flutter/material.dart';

void main() {
  runApp(const BMRCalculatorApp());
}

class BMRCalculatorApp extends StatelessWidget {
  const BMRCalculatorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BMRCalculatorPage(),
    );
  }
}

class BMRCalculatorPage extends StatefulWidget {
  const BMRCalculatorPage({Key? key}) : super(key: key);

  @override
  State<BMRCalculatorPage> createState() => _BMRCalculatorPageState();
}

class _BMRCalculatorPageState extends State<BMRCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController(text: '20');
  final _heightFeetController = TextEditingController(text: '5');
  final _heightInchController = TextEditingController(text: '10');
  final _weightController = TextEditingController(text: '160');
  
  String _gender = 'pria';
  String _unitSystem = 'AS';
  double? _bmr;
  bool _showResults = false;

  @override
  void dispose() {
    _ageController.dispose();
    _heightFeetController.dispose();
    _heightInchController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _calculateBMR() {
    if (_formKey.currentState!.validate()) {
      double age = double.parse(_ageController.text);
      double weight = double.parse(_weightController.text);
      double height;

      if (_unitSystem == 'AS') {
        // Convert feet and inches to cm
        double feet = double.parse(_heightFeetController.text);
        double inches = double.parse(_heightInchController.text);
        height = (feet * 30.48) + (inches * 2.54);
        // Convert pounds to kg
        weight = weight * 0.453592;
      } else {
        // Metric system
        height = double.parse(_heightFeetController.text);
      }

      // Harris-Benedict Formula
      if (_gender == 'pria') {
        _bmr = 88.362 + (13.397 * weight) + (4.799 * height) - (5.677 * age);
      } else {
        _bmr = 447.593 + (9.247 * weight) + (3.098 * height) - (4.330 * age);
      }

      setState(() {
        _showResults = true;
      });
    }
  }

  void _resetForm() {
    setState(() {
      _showResults = false;
      _bmr = null;
      _ageController.text = '20';
      _heightFeetController.text = '5';
      _heightInchController.text = '10';
      _weightController.text = '160';
      _gender = 'pria';
    });
  }

  Map<String, double> _getCaloriesByActivity() {
    if (_bmr == null) return {};
    
    return {
      'Sedentary: sedikit atau tidak ada olahraga': _bmr! * 1.2,
      'Latihan 1-3 kali/minggu': _bmr! * 1.375,
      'Berolahraga 4-5 kali/minggu': _bmr! * 1.465,
      'Olahraga harian atau olahraga intens 3-4 kali/minggu': _bmr! * 1.55,
      'Olahraga intensif 6-7 kali/minggu': _bmr! * 1.725,
      'Olahraga yang sangat intens setiap hari, atau pekerjaan fisik': _bmr! * 1.9,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalkulator BMR'),
        backgroundColor: const Color(0xFF4A6FA5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kalkulator BMR',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C4A7E),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Kalkulator Laju Metabolisme Basal (BMR) memperkirakan laju metabolisme basal Anda—jumlah energi yang dikeluarkan saat istirahat di lingkungan bersuhu netral, dan dalam keadaan pasca-absorptif (artinya sistem pencernaan tidak aktif, yang membutuhkan sekitar 12 jam puasa).',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            
            // Form Section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Unit System Tabs
                    Row(
                      children: [
                        Expanded(
                          child: _buildTab('Unit AS', 'AS'),
                        ),
                        Expanded(
                          child: _buildTab('Satuan Metrik', 'Metrik'),
                        ),
                        Expanded(
                          child: _buildTab('Unit Lainnya', 'Lainnya'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Age Input
                    _buildInputRow(
                      'Usia',
                      _ageController,
                      'tahun',
                      'usia 15 - 80',
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Gender Selection
                    const Text(
                      'Jenis kelamin',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('pria'),
                            value: 'pria',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            title: const Text('perempuan'),
                            value: 'perempuan',
                            groupValue: _gender,
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Height Input
                    Row(
                      children: [
                        const Expanded(
                          flex: 2,
                          child: Text(
                            'Tinggi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _heightFeetController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              suffix: Text(_unitSystem == 'AS' ? 'kaki' : 'cm'),
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              return null;
                            },
                          ),
                        ),
                        if (_unitSystem == 'AS') ...[
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _heightInchController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                suffix: Text('inci'),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Weight Input
                    _buildInputRow(
                      'Berat',
                      _weightController,
                      _unitSystem == 'AS' ? 'pon' : 'kg',
                      '',
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _calculateBMR,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5C7A3D),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hitung',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.play_arrow),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[400],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            child: const Text(
                              'Jelas',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Results Section
            if (_showResults && _bmr != null)
              Container(
                width: double.infinity,
                color: const Color(0xFF6B8E4E),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hasil',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: 'BMR = '),
                          TextSpan(
                            text: '${_bmr!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                          ),
                          const TextSpan(text: ' Kalori/hari'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Kebutuhan kalori harian berdasarkan tingkat aktivitas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4A6FA5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Tingkat Aktivitas',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Kalori',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ..._getCaloriesByActivity().entries.map(
                            (entry) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[300]!,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      entry.value.toStringAsFixed(0),
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Olahraga: 15-30 menit aktivitas dengan detak jantung tinggi.\n'
                      'Olahraga intens: 45-120 menit aktivitas dengan detak jantung tinggi.\n'
                      'Olahraga sangat intens: 2+ jam aktivitas dengan detak jantung tinggi.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, String value) {
    bool isSelected = _unitSystem == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _unitSystem = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4A6FA5) : Colors.grey[300],
          border: Border.all(color: Colors.grey[400]!),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(
    String label,
    TextEditingController controller,
    String suffix,
    String hint,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffix: Text(suffix),
              hintText: hint,
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Required';
              }
              if (double.tryParse(value) == null) {
                return 'Invalid';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}