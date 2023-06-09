import 'package:lottery/main.dart';

class HomeLogic extends GetxController {
  static HomeLogic? logic() => Tool.capture(Get.find);
  final HttpTool _http = HttpTool.getHttp(HomeLogic);

  List list = [];

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  void loadData() {
    _http.get(
      "/prize_list",
      query: {},
      onSuccess: (body) {
        list = body["prizes"];
        update();
      },
      onError: (type, error) {
        Tool.showToast(error);
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          title: const Text("首页"),
          elevation: 1,
        ),
        Expanded(
          child: GetBuilder<HomeLogic>(
            init: HomeLogic(),
            builder: (logic) {
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  16 + SafeTool.instance.safeBtm,
                ),
                itemBuilder: (context, index) {
                  return _buildItem(logic.list[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 16);
                },
                itemCount: logic.list.length,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItem(Map item) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 去详情
        Get.toNamed(Routes.detail, arguments: item["draw_record_id"]);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            AspectRatio(
              aspectRatio: 1.8,
              child: ImageWidget(
                item["prize_icon"],
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned.fill(
              top: null,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: getBlack25,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["prize_desc"],
                      style: const TextStyle(
                        color: getTextWhite,
                        fontSize: 16,
                        fontWeight: getBold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "开奖人数：${item["user_count"] + item["remaining_count"]}人",
                          style: const TextStyle(
                            color: getTextWhite,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "参与人数：${item["user_count"]}人",
                          style: const TextStyle(
                            color: getTextWhite,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "剩余人数：${item["remaining_count"]}人",
                          style: const TextStyle(
                            color: getTextWhite,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (item["is_end"])
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: getBlack25,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Transform.rotate(
                      angle: 25,
                      child: const Text(
                        "已开奖",
                        style: TextStyle(
                          color: getTextWhite,
                          fontSize: 55,
                          fontWeight: getBold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
