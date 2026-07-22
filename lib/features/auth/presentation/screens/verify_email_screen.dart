import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  final String uid;
  final String token;

  const VerifyEmailScreen({super.key, required this.uid, required this.token});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _isLoading = true;
  String _message = '';

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    try {
      final apiClient = ref.read(apiClientProvider);
      await apiClient.dio.post('verify-email-confirm/', data: {
        'uid': widget.uid,
        'token': widget.token,
      });
      setState(() { _message = 'Email verified successfully.'; });
    } catch (e) {
      setState(() { _message = 'Verification failed. The link may be invalid or expired.'; });
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Verification')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24),
                child: Text(_message, textAlign: TextAlign.center),
              ),
      ),
    );
  }
}