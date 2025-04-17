import 'package:assignment/screens/summary_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/form_field-model.dart';
import '../providers/form_provider.dart';
import '../widgets/dynamic_fields.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFC99DEC).withOpacity(0.9),
                  const Color(0xFF4971BC).withOpacity(0.95)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: provider.isLoading
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Loading form fields...',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              )
                  : provider.errorMessage != null
                  ? Center(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Colors.red.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.error_outline,
                            color: Colors.redAccent,
                            size: 56,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Error Loading Form',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          provider.errorMessage!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            elevation: 3,
                          ),
                          onPressed: () => provider.fetchFields(),
                          icon: const Icon(Icons.refresh),
                          label: const Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  : CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    floating: true,
                    expandedHeight: 120,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          'Dynamic Form',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      centerTitle: true,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 30),
                    sliver: SliverToBoxAdapter(
                      child: Card(
                        elevation: 10,
                        shadowColor:
                        const Color(0xFF4971BC).withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.white.withOpacity(0.2),
                            width: 0.5,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Please complete all fields',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF4971BC),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Divider(),
                              const SizedBox(height: 16),
                              ...provider.fields.map((field) => Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20),
                                child: DynamicField(field: field),
                              )),
                              const SizedBox(height: 16),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: double.infinity,
                                  margin:
                                  const EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                      const Color(0xFF00C4B4),
                                      foregroundColor: Colors.white,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                      ),
                                      elevation: 4,
                                    ),
                                    onPressed: () {
                                      if (provider.validate()) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                            const SummaryScreen(),
                                          ),
                                        );
                                      }
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Submit Form',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight:
                                            FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding:
                                          const EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: Colors.white
                                                .withOpacity(0.2),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}