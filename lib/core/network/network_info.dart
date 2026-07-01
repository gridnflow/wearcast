// NetworkInfo now lives in growth_core. Re-exported so existing imports keep
// working; ConnectivityNetworkInfo provides the concrete implementation.
export 'package:growth_core/growth_core.dart'
    show NetworkInfo, ConnectivityNetworkInfo, networkInfoProvider;
