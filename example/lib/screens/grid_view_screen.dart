import 'package:flutter/material.dart';

class GridViewScreen extends StatelessWidget {
  GridViewScreen({Key? key, required this.lazyLoad}) : super(key: key);

  final bool lazyLoad;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    _startTest(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ListView'),
      ),
      body: lazyLoad
          ? GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 64,
                childAspectRatio: 1,
              ),
              itemBuilder: (_, __) => const FlutterLogo(size: 64),
              itemCount: 1500,
            )
          : SingleChildScrollView(
              controller: _scrollController,
              child: Wrap(
                direction: Axis.horizontal,
                children: List.generate(
                  1500,
                  (index) => const FlutterLogo(size: 64),
                ),
              ),
            ),
    );
  }

  Future<void> _startTest(BuildContext context) async {
    await Future.delayed(const Duration(milliseconds: 2000));
    await _scrollController.animateTo(200,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 500));
    await _scrollController.animateTo(400,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 500));
    await _scrollController.animateTo(600,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 500));
    await _scrollController.animateTo(800,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 500));
    await _scrollController.animateTo(7000,
        duration: const Duration(milliseconds: 3000), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 500));
    await _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 3000), curve: Curves.easeInOut);
    await Future.delayed(const Duration(milliseconds: 2000));
    Navigator.of(context).pop();
  }

  /// The FlutterLogo widget can be replaced with Image.Network for testing.
  Widget getImageWidget(String url) => ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 450, maxWidth: 450),
        child: Image.network(
          url,
          fit: BoxFit.cover,
        ),
      );
}

const kImagesList = [
  'https://images.unsplash.com/photo-1617854818583-09e7f077a156?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
  'https://images.freeimages.com/images/large-previews/b9d/grating-1197485.jpg',
  'https://images.freeimages.com/images/large-previews/d27/golden-gate-2004-1235324.jpg',
  'https://images.freeimages.com/images/large-previews/aaa/rusty-1178129.jpg',
  'https://images.freeimages.com/images/large-previews/ead/tunnel-1056859.jpg',
  'https://images.freeimages.com/images/large-previews/980/security-1535172.jpg',
  'https://images.freeimages.com/images/large-previews/6fa/the-tunnel-1231882.jpg',
  'https://images.freeimages.com/images/large-previews/a9a/the-link-1259255.jpg',
  'https://images.freeimages.com/images/large-previews/c80/fence-5-1311796.jpg',
  'https://images.freeimages.com/images/large-previews/726/corridor-1496275.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/81a/florianopolis-1224412.jpg',
  'https://images.freeimages.com/images/large-previews/619/sydney-harbour-bridge-1541507.jpg',
  'https://images.freeimages.com/images/large-previews/9b2/hand-in-action-open-hand-2-1431550.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/8de/missing-link-1519399.jpg',
  'https://images.freeimages.com/images/large-previews/cac/fencing-1217293.jpg',
  'https://media.istockphoto.com/photos/modern-glass-office-building-with-business-people-from-above-picture-id1321598204',
  'https://images.freeimages.com/images/large-previews/0a2/sydney-harbour-1554486.jpg',
  'https://media.istockphoto.com/photos/application-programming-interface-software-development-tool-business-picture-id1317706831',
  'https://images.freeimages.com/images/large-previews/71c/ate-1315806.jpg',
  'https://images.freeimages.com/images/large-previews/866/what-lies-ahead-1521969.jpg',
  'https://images.freeimages.com/images/large-previews/b63/leather-link-texture-1538716.jpg',
  'https://media.istockphoto.com/photos/smart-home-symbol-picture-id1314037715',
  'https://images.freeimages.com/images/large-previews/971/hand-in-action-aiming-3-1431446.jpg',
  'https://images.freeimages.com/images/large-previews/0a7/hi-res-transport-photos-1224586.jpg',
  'https://media.istockphoto.com/photos/media-link-connecting-on-night-city-background-digital-internet-picture-id1313742109',
  'https://images.freeimages.com/images/large-previews/82a/frog-on-chain-link-fence-1560508.jpg',
  'https://images.freeimages.com/images/large-previews/db9/the-weak-link-1427603.jpg',
  'https://images.freeimages.com/images/large-previews/48e/brooklyn-bridge-1566599.jpg',
  'https://images.freeimages.com/images/large-previews/9bd/rusted-fence-decay-texture-1199916.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/d45/sydney-harbour-bridge-1-1213044.jpg',
  'https://images.freeimages.com/images/large-previews/b23/d-link-switch-1243624.jpg',
  'https://images.freeimages.com/images/large-previews/3ff/chain-link-fence-1187948.jpg',
  'https://images.freeimages.com/images/large-previews/9ab/paper-chain-v-2-1314067.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/bc9/golden-gate-fog-1545805.jpg',
  'https://images.freeimages.com/images/large-previews/85c/hand-in-action-open-hand-4-1431534.jpg',
  'https://images.freeimages.com/images/large-previews/53d/leather-link-texture-1538412.jpg',
  'https://images.unsplash.com/photo-1617854818583-09e7f077a156?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
  'https://images.freeimages.com/images/large-previews/b9d/grating-1197485.jpg',
  'https://images.freeimages.com/images/large-previews/d27/golden-gate-2004-1235324.jpg',
  'https://images.freeimages.com/images/large-previews/aaa/rusty-1178129.jpg',
  'https://images.freeimages.com/images/large-previews/ead/tunnel-1056859.jpg',
  'https://images.freeimages.com/images/large-previews/980/security-1535172.jpg',
  'https://images.freeimages.com/images/large-previews/6fa/the-tunnel-1231882.jpg',
  'https://images.freeimages.com/images/large-previews/a9a/the-link-1259255.jpg',
  'https://images.freeimages.com/images/large-previews/c80/fence-5-1311796.jpg',
  'https://images.freeimages.com/images/large-previews/726/corridor-1496275.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/81a/florianopolis-1224412.jpg',
  'https://images.freeimages.com/images/large-previews/619/sydney-harbour-bridge-1541507.jpg',
  'https://images.freeimages.com/images/large-previews/9b2/hand-in-action-open-hand-2-1431550.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/8de/missing-link-1519399.jpg',
  'https://images.freeimages.com/images/large-previews/cac/fencing-1217293.jpg',
  'https://media.istockphoto.com/photos/modern-glass-office-building-with-business-people-from-above-picture-id1321598204',
  'https://images.freeimages.com/images/large-previews/0a2/sydney-harbour-1554486.jpg',
  'https://media.istockphoto.com/photos/application-programming-interface-software-development-tool-business-picture-id1317706831',
  'https://images.freeimages.com/images/large-previews/71c/ate-1315806.jpg',
  'https://images.freeimages.com/images/large-previews/866/what-lies-ahead-1521969.jpg',
  'https://images.freeimages.com/images/large-previews/b63/leather-link-texture-1538716.jpg',
  'https://media.istockphoto.com/photos/smart-home-symbol-picture-id1314037715',
  'https://images.freeimages.com/images/large-previews/971/hand-in-action-aiming-3-1431446.jpg',
  'https://images.freeimages.com/images/large-previews/0a7/hi-res-transport-photos-1224586.jpg',
  'https://media.istockphoto.com/photos/media-link-connecting-on-night-city-background-digital-internet-picture-id1313742109',
  'https://images.freeimages.com/images/large-previews/82a/frog-on-chain-link-fence-1560508.jpg',
  'https://images.freeimages.com/images/large-previews/db9/the-weak-link-1427603.jpg',
  'https://images.freeimages.com/images/large-previews/48e/brooklyn-bridge-1566599.jpg',
  'https://images.freeimages.com/images/large-previews/9bd/rusted-fence-decay-texture-1199916.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/d45/sydney-harbour-bridge-1-1213044.jpg',
  'https://images.freeimages.com/images/large-previews/b23/d-link-switch-1243624.jpg',
  'https://images.freeimages.com/images/large-previews/3ff/chain-link-fence-1187948.jpg',
  'https://images.freeimages.com/images/large-previews/9ab/paper-chain-v-2-1314067.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/bc9/golden-gate-fog-1545805.jpg',
  'https://images.freeimages.com/images/large-previews/85c/hand-in-action-open-hand-4-1431534.jpg',
  'https://images.freeimages.com/images/large-previews/53d/leather-link-texture-1538412.jpg',
  'https://images.unsplash.com/photo-1617854818583-09e7f077a156?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1740&q=80',
  'https://images.freeimages.com/images/large-previews/b9d/grating-1197485.jpg',
  'https://images.freeimages.com/images/large-previews/d27/golden-gate-2004-1235324.jpg',
  'https://images.freeimages.com/images/large-previews/aaa/rusty-1178129.jpg',
  'https://images.freeimages.com/images/large-previews/ead/tunnel-1056859.jpg',
  'https://images.freeimages.com/images/large-previews/980/security-1535172.jpg',
  'https://images.freeimages.com/images/large-previews/6fa/the-tunnel-1231882.jpg',
  'https://images.freeimages.com/images/large-previews/a9a/the-link-1259255.jpg',
  'https://images.freeimages.com/images/large-previews/c80/fence-5-1311796.jpg',
  'https://images.freeimages.com/images/large-previews/726/corridor-1496275.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/81a/florianopolis-1224412.jpg',
  'https://images.freeimages.com/images/large-previews/619/sydney-harbour-bridge-1541507.jpg',
  'https://images.freeimages.com/images/large-previews/9b2/hand-in-action-open-hand-2-1431550.jpg',
  'https://images.freeimages.com/images/large-previews/0bf/missing-link-1195723.jpg',
  'https://images.freeimages.com/images/large-previews/8de/missing-link-1519399.jpg',
  'https://images.freeimages.com/images/large-previews/cac/fencing-1217293.jpg',
  'https://media.istockphoto.com/photos/modern-glass-office-building-with-business-people-from-above-picture-id1321598204',
  'https://images.freeimages.com/images/large-previews/0a2/sydney-harbour-1554486.jpg',
  'https://media.istockphoto.com/photos/application-programming-interface-software-development-tool-business-picture-id1317706831',
  'https://images.freeimages.com/images/large-previews/71c/ate-1315806.jpg',
  'https://images.freeimages.com/images/large-previews/866/what-lies-ahead-1521969.jpg',
  'https://images.freeimages.com/images/large-previews/b63/leather-link-texture-1538716.jpg',
  'https://media.istockphoto.com/photos/smart-home-symbol-picture-id1314037715',
  'https://images.freeimages.com/images/large-previews/971/hand-in-action-aiming-3-1431446.jpg',
  'https://images.freeimages.com/images/large-previews/0a7/hi-res-transport-photos-1224586.jpg',
  'https://media.istockphoto.com/photos/media-link-connecting-on-night-city-background-digital-internet-picture-id1313742109',
  'https://images.freeimages.com/images/large-previews/82a/frog-on-chain-link-fence-1560508.jpg',
  'https://images.freeimages.com/images/large-previews/db9/the-weak-link-1427603.jpg',
  'https://images.freeimages.com/images/large-previews/48e/brooklyn-bridge-1566599.jpg',
  'https://images.freeimages.com/images/large-previews/9bd/rusted-fence-decay-texture-1199916.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/d45/sydney-harbour-bridge-1-1213044.jpg',
  'https://images.freeimages.com/images/large-previews/b23/d-link-switch-1243624.jpg',
  'https://images.freeimages.com/images/large-previews/3ff/chain-link-fence-1187948.jpg',
  'https://images.freeimages.com/images/large-previews/9ab/paper-chain-v-2-1314067.jpg',
  'https://images.freeimages.com/images/large-previews/3bc/bridge-1527884.jpg',
  'https://images.freeimages.com/images/large-previews/bc9/golden-gate-fog-1545805.jpg',
  'https://images.freeimages.com/images/large-previews/85c/hand-in-action-open-hand-4-1431534.jpg',
  'https://images.freeimages.com/images/large-previews/53d/leather-link-texture-1538412.jpg',
];
