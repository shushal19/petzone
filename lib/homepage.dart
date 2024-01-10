// homepage.dart
import 'package:flutter/material.dart';
import 'package:petzone/models/user_model.dart';
import 'package:petzone/services/http_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HttpService http;
  List<UsersModel> _userData = [];
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    http = HttpService();
    getUsersDetail();
  }

  Future<void> getUsersDetail() async {
    try {
      setState(() {
        isLoading = true;
        isError = false; // Reset error flag on new request
      });

      final response = await http.getRequest("get_doctor.php");

      if (response.statusCode == 200) {
        final List<dynamic> userDataList = response.data;
        setState(() {
          _userData = userDataList.map((userData) => UsersModel.fromJson(userData)).toList();
        });
      } else {
        setState(() {
          isError = true;
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : isError
              ? const Center(child: Text('Error occurred while fetching data'))
              : _userData.isEmpty
                  ? const Center(child: Text('No data available'))
                  : ListView.builder(
                      itemCount: _userData.length,
                      itemBuilder: (context, index) {
                        final user = _userData[index];
                        return ListTile(
                          title: Text(user.firstName),
                          subtitle: Text(user.email),
                          // Display other user details as needed
                        );
                      },
                    ),
    );
  }
}
