import 'package:dong_ho_bao_thuc/styles.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _baoLai = true;
  bool _henGio = true;

  Future<void> _loadBaoLai() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _baoLai = prefs.getBool('bao_lai') ?? true;
    });
  }

  Future<void> _saveBaoLai() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('bao_lai', _baoLai);
    });
  }

  Future<void> _loadHenGio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _henGio = prefs.getBool('hen_gio') ?? true;
    });
  }

  Future<void> _saveHenGio() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setBool('hen_gio', _henGio);
    });
  }

  @override
  void initState() {
    _loadBaoLai();
    _loadHenGio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Stack(
            children: [
              Image.asset(
                'images/app_bar_small.jpg',
                //fit: BoxFit.cover,
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Text(
                    'Cài đặt',
                    textAlign: TextAlign.center,
                    style: Styles.titleLarge.copyWith(
                      color: Colors.white,
                    ),
                  )),
              Positioned(
                  left: 5,
                  bottom: 0,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ))),
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SeparatedColumn(
              separatorBuilder: () => SizedBox(
                height: 5,
              ),
              children: [
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'Tắt báo lại',
                        style: Styles.titleSmall,
                      ),
                      trailing: CupertinoSwitch(
                        onChanged: (value) {
                          _baoLai = !value;
                          _saveBaoLai();
                        },
                        value: !_baoLai,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'Nhạc chuông hẹn giờ',
                        style: Styles.titleSmall,
                      ),
                      trailing: CupertinoSwitch(
                        onChanged: (value) {
                          _henGio = value;
                          _saveHenGio();
                        },
                        value: _henGio,
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'Chính sách bảo mật',
                        style: Styles.titleSmall,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                      body: Column(children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'images/app_bar_small.jpg',
                                          //fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 10,
                                            child: Text(
                                              'Chính sách bảo mật',
                                              textAlign: TextAlign.center,
                                              style: Styles.titleLarge.copyWith(
                                                color: Colors.white,
                                              ),
                                            )),
                                        Positioned(
                                            left: 5,
                                            bottom: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ))),
                                      ],
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              '''1. Giới thiệu: Ứng dụng Đồng Hồ Báo Thức cung cấp một loạt các tính năng để cá nhân hóa trải nghiệm thức dậy của bạn.
      2. Thông tin thu thập: Chúng tôi thu thập thông tin cơ bản như ngôn ngữ mà bạn sử dụng, thời gian báo thức và cập nhật báo thức.
      3. Cách sử dụng thông tin: Thông tin thu thập được sử dụng để cung cấp và cải thiện dịch vụ, cung cấp hỗ trợ kỹ thuật và giao tiếp với bạn.
      4. Chia sẻ thông tin: Chúng tôi không chia sẻ thông tin cá nhân của bạn với bên thứ ba trừ khi có sự đồng ý của bạn hoặc theo yêu cầu của pháp luật.
      5. Bảo mật thông tin: Chúng tôi sử dụng các biện pháp bảo mật kỹ thuật và tổ chức để bảo vệ thông tin cá nhân của bạn khỏi truy cập, sử dụng hoặc tiết lộ không hợp pháp.
      6. Quyền của người dùng: Bạn có quyền truy cập, cập nhật, quản lý, xuất và xóa thông tin của mình.
      7. Cập nhật chính sách: Chúng tôi sẽ thông báo cho bạn về bất kỳ thay đổi đáng kể nào trong chính sách bảo mật này.
      ''',
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                  ])))),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        'Giới thiệu',
                        style: Styles.titleSmall,
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Scaffold(
                                      body: Column(children: [
                                    Stack(
                                      children: [
                                        Image.asset(
                                          'images/app_bar_small.jpg',
                                          //fit: BoxFit.cover,
                                        ),
                                        Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 10,
                                            child: Text(
                                              'Giới thiệu',
                                              textAlign: TextAlign.center,
                                              style: Styles.titleLarge.copyWith(
                                                color: Colors.white,
                                              ),
                                            )),
                                        Positioned(
                                            left: 5,
                                            bottom: 0,
                                            child: IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.white,
                                                ))),
                                      ],
                                    ),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Chào mừng bạn đến với ứng dụng Đồng Hồ Báo Thức - ứng dụng đồng hồ báo thức đa năng, giúp bạn tùy chỉnh trải nghiệm thức dậy theo cách riêng của mình. Với Đồng Hồ Báo Thức, bạn có thể:\n   - Đặt nhiều báo thức khác nhau, báo thức định kỳ hoặc một lần, cho các ngày trong tuần hoặc ngày lễ.\n   - Chọn nhạc chuông, bản nhạc thư giãn, thức dậy cùng với đài phát thanh hoặc podcast yêu thích của bạn.\n   - Đặt hẹn giờ ngủ với âm nhạc thư giãn hoặc đài radio êm dịu.',
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              'Version: 0.1.0',
                                              textAlign: TextAlign.justify,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                  ])))),
                    ),
                  ),
                ),
              ],
            ),
          ))
        ]));
  }
}
